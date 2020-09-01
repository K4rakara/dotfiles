const fs = require('fs');

let from = fs.readFileSync('./index.min.js', 'utf8');

from = '#!/usr/bin/node\n' + from;

fs.writeFileSync('./jsgrep', from);
