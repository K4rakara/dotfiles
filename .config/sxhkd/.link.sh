#!/usr/bin/bash

[ -d ~/.config/sxhkd ] || mkdir -p ~/.config/sxhkd/;

ln -s -f $PWD/.config/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc;

