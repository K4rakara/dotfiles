#!/usr/bin/bash

[ -d "~/.config/freshfetch/" ] || mkdir -p ~/.config/freshfetch/;

for file in $PWD/.config/freshfetch/*.lua; do
  [ -f "$file" ] || break;
  file=${file##*/};
  ln -s -f "$PWD/.config/freshfetch/$file" ~/.config/freshfetch/$file;
done;

