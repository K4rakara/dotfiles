#!/usr/bin/bash

[ -d ~/.config/picom/ ] || mkdir -p ~/.config/picom/;

ln -s -f "$PWD/.config/picom/picom.conf" ~/.config/picom/picom.conf;

