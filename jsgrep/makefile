all:
	@echo "Compiling JSGrep..."
	@echo "Compiling TypeScript..."
	@yarn tsc;
	@echo "Minifying..."
	@yarn babel-minify ./index.js --out-file ./index.min.js
	@echo "Finishing up..."
	@node ./make.js

install:
	@./install.sh global

install-local:
	@./install.sh
