import process from 'process';

if (process.argv[2] != null)
{
	let input: string = '';
	let flags: string = '';
	if (process.argv[3] != null) flags = process.argv[3];

	const stdin: NodeJS.Socket = process.openStdin();

	stdin.on('data', (chunk: string): void =>
		{ input += chunk; });

	stdin.on('end', (): void =>
	{
		const regExp: RegExp = new RegExp(process.argv[2], flags);
		const matches: RegExpMatchArray|null = regExp.exec(input);
		if (matches != null) matches.forEach((match: string): void => console.log(match));
		process.exit();
	});
}
