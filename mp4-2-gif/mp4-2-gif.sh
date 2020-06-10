#!/usr/bin/bash
ffmpeg \
	-i `echo $1` \
	-r `mediainfo --fullscan $1 | jsgrep "(?<=Frame count                              : )\d+"` \
	-vf "scale=`mediainfo --fullscan $1 | jsgrep "(?<=Height                                   : )\d+(?= pixels)"`:-1,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
	-ss 00:00:00 -to `mediainfo --fullscan $1 | jsgrep "(?<=Duration                                 : )\d\d:\d\d:\d\d.\d+" | round-time-up` \
	$2
