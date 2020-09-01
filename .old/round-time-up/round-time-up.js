#!/usr/bin/node
const process = require('process');

function padNumber(v)
{
	if (typeof v === 'number')
	{
		let asString = v.toString();
		while (asString.length < 2) asString = "0" + asString;
		return asString;
	}
	else throw new Error('v is not a number!');
}

const stdin = process.openStdin();
let data = '';

stdin.on('data', (v) => { data += v; });

stdin.on('end', () =>
{
	let hours = parseInt(/\d\d(?=:\d\d:\d\d.\d+)/gm.exec(data)[0]);
	let minutes = parseInt(/(?<=\d\d:)\d\d(?=:\d\d.\d+)/gm.exec(data)[0]);
	let seconds = parseInt(/(?<=\d\d:\d\d:)\d\d(?=.\d+)/gm.exec(data)[0]);
	let milliseconds = parseInt(/(?<=\d\d:\d\d:\d\d.)\d+/gm.exec(data)[0]);
	if (milliseconds >= 500) seconds++;
	if (seconds >= 60) { minutes += (seconds - 60); seconds -= 60; }
	if (minutes >= 60) { hours += (minutes - 60); minutes -= 60; }
	console.log(`${padNumber(hours)}:${padNumber(minutes)}:${padNumber(seconds)}`);
	process.exit();
});
