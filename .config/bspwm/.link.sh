#!/usr/bin/bash

[ -d ~/.config/bspwm/ ] || mkdir -p ~/.config/bspwm/;

ln -s -f $PWD/.config/bspwm/bspwmrc ~/.config/bspwm/bspwmrc;

