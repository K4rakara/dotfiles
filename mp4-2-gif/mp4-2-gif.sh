#!/usr/bin/bash

frameCount="0"
height="1024"
duration="00:00:00"

printHelp() {
echo "
mp4-2-gif v0.0.2

Usage:

mp4-2-gif [input file.mp4] [output file.gif]
"
}

getFrameCount() {
	frameCount=`mediainfo --fullscan $1 | jsgrep -o --color=none -m 1 "(?<=Frame count                              : )\d+"`
}

getHeight() {
	tmpHeight=`mediainfo --fullscan $1 | jsgrep -o --color=none -m 1 "(?<=Height                                   : )\d+"`
	if [ -z "$tmpHeight" ]
	then
		height="$tmpHeight"
	fi
}

getDuration() {
	duration=`mediainfo --fullscan $1 | jsgrep -o --color=none "(?<=Duration                                 : )\d\d:\d\d:\d\d.\d+" | round-time-up`
}

if [ "$1" != "" ]
then
	if [ "$2" != "" ]
	then
		getFrameCount $1
		getHeight $1
		getDuration $1
		ffmpeg \
			-i `echo $1` \
			-r $frameCount \
			-vf "scale=$height:-1,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
			-ss 00:00:00 -to $duration \
			$2
	else
		printHelp
	fi
else
	printHelp
fi
