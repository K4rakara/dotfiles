const fs = require('fs');

let content = fs.readFileSync('./index.min.js', 'utf8');
content = '#!/usr/bin/node\n' + content;
fs.writeFileSync('./wf', content);
