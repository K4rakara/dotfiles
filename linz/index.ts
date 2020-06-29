import fs from 'fs';
import path from 'path';
import clml from 'clml';

const indent: string = clml`\r<forward ${((process.stdout.isTTY) ? Math.round(process.stdout.getWindowSize()[0] * (12.5/100)).toString() : '25')}>`;

const help = clml`
<:memo:> <magenta>linz<reset> <bold>v0.0.1<reset>

Count up the number of lines of code in the current directory with ease.

<bold>Usage:<reset>

linz [options]

<bold>Options:<reset>
⚬ +ext:... ${indent}: Include files with the provided extension.
⚬ -ext:... ${indent}: Don't include files with the provided extension.
⚬ +file:... ${indent}: Include files with the provided name.
⚬ -file:... ${indent}: Don't include files with the provided name.
⚬ +dir:... ${indent}: Include files from the provided directory.
⚬ -dir:... ${indent}: Don't include files from the provided directory.

<bold>Example:<reset>

linz +ext:ts +ext:tsx -dir:node_modules
`;

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

if (process.argv[2] != null)
{
	const extsToCount: string[] = [];
	const extsToIgnore: string[] = [];
	const filesToCount: string[] = [];
	const filesToIgnore: string[] = [];
	const dirsToCount: string[] = [];
	const dirsToIgnore: string[] = [];
	process.argv.forEach((arg: string, i: number): void =>
	{
		if (i >= 2)
			if (arg.startsWith('+ext:'))
				extsToCount.push(arg.substring(5));
			else if (arg.startsWith('-ext:'))
				extsToIgnore.push(arg.substring(5));
			else if (arg.startsWith('+file:'))
				filesToCount.push(arg.substring(6));
			else if (arg.startsWith('-file:'))
				filesToIgnore.push(arg.substring(6));
			else if (arg.startsWith('+dir:'))
				dirsToCount.push(arg.substring(5));
			else if (arg.startsWith('-dir:'))
				dirsToIgnore.push(arg.substring(5));
			else
			{
				console.log(help);
				process.exit();
			}
	});

	const matches: string[] = readDirRecursive(process.cwd())
		.filter((v: string): boolean =>
		{
			let toReturn: boolean = false;
			if (extsToCount.includes(path.parse(v).ext.substring(1))) toReturn = true;
			if (filesToCount.includes(path.parse(v).base)) toReturn = true;
			dirsToCount.forEach((dir: string): void =>
				{ if (path.parse(v).dir.includes(dir)) toReturn = true; });
			if (extsToIgnore.includes(path.parse(v).ext.substring(1))) toReturn = false;
			if (filesToIgnore.includes(path.parse(v).base)) toReturn = false;
			dirsToIgnore.forEach((dir: string): void =>
				{ if (path.parse(v).dir.includes(dir)) toReturn = false; });
			return toReturn;
		});

	let lines: number = 0;

	matches.forEach((match: string): void =>
	{
		let content: string = '';
		try { content = fs.readFileSync(match, 'utf8'); }
		catch {}
		lines += content.split('\n').length - 1;
	});

	console.log(lines);
}
else
{
	console.log(help);
	process.exit();
}