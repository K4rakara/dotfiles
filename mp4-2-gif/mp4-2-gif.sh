#!/usr/bin/bash
printHelp() {
echo "
mp4-2-gif v0.0.1

Usage:

mp4-2-gif [input file.mp4] [output file.gif]
"
}

if [ "$1" != "" ]
then
	if ["$2" != ""]
	then
		ffmpeg \
			-i `echo $1` \
			-r `mediainfo --fullscan $1 | jsgrep -o --color=none "(?<=Frame count                              : )\d+"` \
			-vf "scale=`mediainfo --fullscan $1 | jsgrep -o --color=none "(?<=Height                                   : )\d+(?= pixels)"`:-1,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
			-ss 00:00:00 -to `mediainfo --fullscan $1 | jsgrep -o --color=none "(?<=Duration                                 : )\d\d:\d\d:\d\d.\d+" | round-time-up` \
			$2		
	else
		printHelp
	fi
else
	printHelp
fi
