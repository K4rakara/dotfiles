import fs from 'fs';
import path from 'path';
import yargs from 'yargs';
import clml from 'clml';

const indent: string = clml`\r<forward ${((process.stdout.isTTY) ? Math.round(process.stdout.getWindowSize()[0] * (12.5/100)).toString() : '25')}>`;

const help: string =
clml`
<:mag:> <yellow>js<reset>grep <bold>v0.0.4<reset>

<bold>Usage:<reset>

jsgrep [options] regexp [files]

<bold>Options:<reset>

⚬ --help, -h ${indent}: Display this help text and exit.
⚬ --flags, f ...${indent}: Specify flags for the regexp to use.
⚬ --invert-match, -v${indent}: Select non-matching lines.
⚬ --max-count, -m ...${indent}: Stop after a given number of matches.
⚬ --color ...${indent}: Set the display color. Defaults to red. Acceptable values are:
<forward 5>⚬ black
<forward 5>⚬ blue
<forward 5>⚬ cyan
<forward 5>⚬ green
<forward 5>⚬ magenta
<forward 5>⚬ red
<forward 5>⚬ white
<forward 5>⚬ yellow
`;

const argv = yargs
	.boolean('h')
	.alias('h', 'help')
	.string('color')
	.boolean('v')
	.alias('v', 'invert-match')
	.string('f')
	.alias('f', 'flags')
	.boolean('o')
	.alias('o', 'only-matching')
	.number('m')
	.alias('m', 'max-count')
	.help(false)
	.argv;

function readDirRecursive(dir: string): string[]
{
	const toReturn: string[] = [];
	const directChildren: string[] = fs.readdirSync(dir, 'utf8');
	directChildren.forEach((child: string): void =>
	{
		let isDir: boolean = false;
		try { fs.readFileSync(path.join(dir, child), 'utf8'); }
		catch { isDir = true }
		if (!isDir)
			toReturn.push(path.join(dir, child));
		else
			toReturn.push(...readDirRecursive(path.join(dir, child)));
	});
	return toReturn;
}

if (argv._.length >= 1)
{
	if (argv.h != null && argv.h) { console.log(help); process.exit(); }
	let count: number = 0;
	const maybeExit = (output: string): void => { if (argv.m != null) if (count >= argv.m) { console.log(output); process.exit(); } };
	if (process.stdin.isTTY)
	{
		const regexp: RegExp = new RegExp(argv._[0], argv.f || '');

		if (argv._[1] != null)
		{
			argv._.forEach((arg: string, i: number): void =>
			{
				if (i >= 1)
				{
					let isDir: boolean = false;
					try { fs.readFileSync(path.join(process.cwd(), arg), 'utf-8'); }
					catch { isDir = true; }

					if (!isDir)
					{
						const input: string = fs.readFileSync(path.join(process.cwd(), arg), 'utf8');

						const prefix: string = ((argv.color != null && argv.color !== 'none') || !(argv.color != null))
							? clml`<magenta>${arg}<reset><blue>:<reset> `
							: `${arg}: `;

						let output: string = '';

						input.split(/\n/gmi).forEach((line: string, i: number): void =>
						{
							const matches: RegExpMatchArray|null = regexp.exec(line);

							if (!argv.v)
								if (matches != null)
									if (argv.o)
									{
										output 
											+= ((output !== '') ? '\n': '')
											+ ((!(argv.o != null) || !argv.o) ? prefix : '')
											+ ((!(argv.o != null)
												? ((argv.color != null && argv.color !== 'none') || !(argv.color != null))
													? clml`<blue>${i.toString()}<reset>: `
													: `${i.toString()}: `
												: '')) 
											+ matches[0];
										count++;
										maybeExit(output);
									}
									else
									{
										output
											+= ((output !== '') ? '\n': '')
											+ ((!(argv.o != null) || !argv.o) ? prefix : '')
											+ ((!(argv.o != null)
												? ((argv.color != null && argv.color !== 'none') || !(argv.color != null))
													? clml`<blue>${i.toString()}<reset>: `
													: `${i.toString()}: `
												: '')) 
											+ line.replace(matches[0], clml`${
												((argv.color != null && argv.color !== 'none') || !(argv.color != null))
													? `<${argv.color || 'red'}>${matches[0]}<reset>`
													: matches[0]
											}`);
										count++;
										maybeExit(output);
									}
								else;
							else if (!(matches != null))
							{
								output
									+= ((output !== '') ? '\n': '')
									+ ((!(argv.o != null) || !argv.o) ? prefix : '')
									+ ((!(argv.o != null)
										? ((argv.color != null && argv.color !== 'none') || !(argv.color != null))
											? clml`<blue>${i.toString()}<reset>: `
											: `${i.toString()}: `
										: '')) 
									+ line;
								count++;
								maybeExit(output);
							}
						});

						if (output !== '') console.log(output);
					}
				}
			});
		}
		else
		{
			const inputFiles: string[] = readDirRecursive(process.cwd());
			inputFiles.forEach((inputFile: string): void =>
			{
				const input: string = fs.readFileSync(inputFile, 'utf8');

				const prefix: string = ((argv.color != null && argv.color !== 'none') || !(argv.color != null))
					? clml`<magenta>${inputFile}<reset><blue>:<reset> `
					: `${inputFile}: `;

				let output: string = '';

				input.split(/\n/gmi).forEach((line: string, i: number): void =>
				{
					const matches: RegExpMatchArray|null = regexp.exec(line);

					if (!argv.v)
						if (matches != null)
							if (argv.o)
							{
								output 
									+= ((output !== '') ? '\n': '')
									+ ((!(argv.o != null) || !argv.o) ? prefix : '')
									+ ((!(argv.o != null)
										? ((argv.color != null && argv.color !== 'none') || !(argv.color != null))
											? clml`<blue>${i.toString()}<reset>: `
											: `${i.toString()}: `
										: '')) 
									+ matches[0];
								count++;
								maybeExit(output);
							}
							else
							{
								output
									+= ((output !== '') ? '\n': '')
									+ ((!(argv.o != null) || !argv.o) ? prefix : '')
									+ ((!(argv.o != null)
										? ((argv.color != null && argv.color !== 'none') || !(argv.color != null))
											? clml`<blue>${i.toString()}<reset>: `
											: `${i.toString()}: `
										: '')) 
									+ line.replace(matches[0], clml`${
										((argv.color != null && argv.color !== 'none') || !(argv.color != null))
											? `<${argv.color || 'red'}>${matches[0]}<reset>`
											: matches[0]
									}`);
								count++;
								maybeExit(output);
							}
						else;
					else if (!(matches != null))
					{
						output
							+= ((output !== '') ? '\n': '')
							+ ((!(argv.o != null) || !argv.o) ? prefix : '')
							+ ((!(argv.o != null)
								? ((argv.color != null && argv.color !== 'none') || !(argv.color != null))
									? clml`<blue>${i.toString()}<reset>: `
									: `${i.toString()}: `
								: '')) 
							+ line;
						count++;
						maybeExit(output);
					}
				});

				if (output !== '') console.log(output);
			});
		}
	}
	else
	{
		let input: string = '';
		
		const stdin: NodeJS.Socket = process.openStdin();

		stdin.on('data', (chunk: string): void => { input += chunk; });

		stdin.on('end', (): void =>
		{
			const regexp: RegExp = new RegExp(argv._[0], argv.f || '');
			
			let output: string = '';

			input.split(/\n/gmi).forEach((line: string): void =>
			{
				const matches: RegExpMatchArray|null = regexp.exec(line);

				if (!argv.v)
					if (matches != null)
						if (argv.o)
						{
							output += ((output !== '') ? '\n': '') + matches[0];
							count++;
							maybeExit(output);
						}
						else
						{
							output += ((output !== '') ? '\n': '') + line.replace(matches[0], clml`${
								((argv.color != null && argv.color !== 'none') || !(argv.color != null))
									? `<${argv.color || 'red'}>${matches[0]}<reset>`
									: matches[0]
							}`);
							count++;
							maybeExit(output);
						}
					else;
				else if (!(matches != null))
				{
					output
						+= ((output !== '') ? '\n': '')
						+ line;
					count++;
					maybeExit(output);
				}
			});

			if (output !== '') console.log(output);

			process.exit();
		});
	}
}
else console.log(help);