import http from 'http';
import express from 'express';
import ora from 'ora';

const args =
{
	port: 8080,
};

process.argv.forEach((v: string, i: number): void =>
{
	if (i > 2)
		try { args.port = parseInt(v); }
		catch(err) {}
})

const spinner: ora.Ora = ora();

spinner.start('Starting webserver...');

const app: express.Express = express();

app.use(express.static(process.cwd()));

const server: http.Server = app.listen(args.port);

spinner.succeed("Started webserver.");

process.on('SIGINT', (): void =>
{
	spinner.start('Stopping webserver...');
	server.close();
	spinner.succeed('Stopped webserver.');
});
