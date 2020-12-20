#!/usr/bin/bash

mkdir -p ~/.config/discocss/;

url=$(echo "

const fs = require('fs');

const input = fs.readFileSync('$PWD/.config/discocss/custom.scss', 'UTF-8');

const url = input.matchAll(/\\/\\*IMPORT INLINE \\\"(.*?)\\\"\\*\\//gm).next().value[1];

console.log(url);

" | node);

echo $url;

export content=$(curl $url);

echo "

const fs = require('fs');

const input = fs.readFileSync('$PWD/.config/discocss/custom.scss', 'UTF-8');

const output = input.replace(/\\/\\*IMPORT INLINE \\\"(.*?)\\\"\\*\\//gm, process.env['content']);

console.log(output);

" | node > $PWD/.config/discocss/custom-processed.scss;

type -p sass > /dev/null;

if [[ $? == 0 ]]; then
  sass \
	  --no-source-map \
	  --style compressed \
	  $PWD/.config/discocss/custom-processed.scss:$PWD/.config/discocss/custom.css;
  ln -s -f $PWD/.config/discocss/custom.css ~/.config/discocss/custom.css;
else
  echo "Warning: Sass is not installed. Skipping DiscoCSS.";
fi;

rm $PWD/.config/discocss/custom-processed.scss;

