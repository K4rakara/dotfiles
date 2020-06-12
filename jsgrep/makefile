all:
	@echo "Compiling JSGrep..."
	@echo "Compiling TypeScript..."
	@yarn tsc;
	@echo "Browserifying..."
	@yarn browserify ./index.js --node --bare -o ./index.bundle.js
	@echo "Minifying..."
	@yarn babel-minify ./index.bundle.js --out-file ./index.min.js
	@echo "Finishing up..."
	@node ./make.js

install:
	@./install.sh global

install-local:
	@./install.sh
