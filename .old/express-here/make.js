const fs = require('fs');

let from = fs.readFileSync('./tmp/babel-minify/index.js', 'utf8');

from = '#!/usr/bin/node\n' + from;

fs.writeFileSync('./express-here', from);
