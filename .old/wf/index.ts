import fs from 'fs';
import path from 'path';
import express from 'express';
import bodyParser from 'body-parser';
import ora from 'ora';
import fetch from 'node-fetch';
import btoa from 'btoa';
import atob from 'atob';
import clml from 'clml';

const help = clml`
<:satellite:> <blue>wf<reset> <bold>v0.0.1<reset>

<bold>Usage:<reset>

wf send [file] [url]
wf recv [port]
`;

if (process.argv[2] != null)
{
	if (process.argv[2].toLowerCase() === 'send')
	{
		if (process.argv[3] != null && process.argv[4] != null)
		{
			const spinner: ora.Ora = ora('Sending file...').start();

			let content: string;
			try { content = fs.readFileSync(`${process.argv[3]}`, 'utf8'); }
			catch { spinner.fail(); console.log(`Failed to read file "${process.argv[3]}".`); console.log(help); process.exit(); }

			(async (): Promise<void> =>
			{
				const res = await
				(
					await fetch
					(
						process.argv[4],
						{
							method: 'POST',
							headers: { 'x-submitter': 'wf', 'x-yes-im-using-a-header-for-body-data-leave-me-alone-its-not-working': btoa(content) },
						}
					)
				).json();

				console.log(res);
				
				if (!JSON.stringify(res).includes('Error'))
					return Promise.resolve();
				else
					return Promise.reject(res);
			})()
				.then((): void =>
					{ spinner.succeed('File sent.'); })
				.catch((error): void =>
					{ spinner.fail('Couldn\'t send file. (Recipient returned an error)'); console.log(error) });
		}
		else
			console.log(help);
	}
	else if (process.argv[2].toLowerCase() === 'recv')
	{
		const spinner: ora.Ora = ora('Receiving files...').start();

		let port: number = 8080;
		if (process.argv[3] != null)
			try { port = parseInt(process.argv[3]); }
			catch { console.log(`Expected number, got "${process.argv[3]}"`); console.log(help); process.exit(); }
		
		const app: express.Express = express();
		app.use(bodyParser.raw({ inflate: true }));
		app.use((req, res) =>
		{
			if (req.method === 'POST')
			{
				if (req.headers['x-submitter'] === 'wf')
				{
					const outFile: string = path.join(process.cwd(), req.path);
					try
					{
						fs.writeFileSync(outFile, atob(<string>req.headers['x-yes-im-using-a-header-for-body-data-leave-me-alone-its-not-working']!.toString()));
						res.set('Content-Type', 'application/json');
						res.writeHead(200);
						res.write('{"message": "OK"}');
						res.end();
						spinner.succeed(`Received "${outFile}".`);
						spinner.start('Receiving files...');
					}
					catch(err)
					{
						console.log(err);
						res.set('Content-Type', 'application/json');
						res.writeHead(500);
						res.write('{"message": "Error. Failed to save file."}');
						res.end();
						spinner.fail(`Failed to receive "${outFile}".`);
						spinner.start('Receiving files...');
					}
				}
				else
				{
					res.set('Content-Type', 'application/json');
					res.writeHead(400);
					res.write('{"message": "Error. Expected a POST request from a wf binary."}');
					res.end();
				}
			}
			else
			{
				res.set('Content-Type', 'application/json');
				res.writeHead(400);
				res.write('{"message": "Error. Expected POST method."}');
				res.end();
			}
		});
		const server = app.listen(port);

		process.on('SIGINT', (): void =>
		{
			server.close();
			spinner.succeed('Files received.');
		});
	}
	else
		console.log(help);
}
else
	console.log(help);
