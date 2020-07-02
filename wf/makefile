.PHONY: all install ts browserify babel-minify finish

all: install ts browserify babel-minify finish

install:
	@echo "Installing packages..."
	@yarn

ts:
	@echo "Compiling TypeScript..."
	@yarn tsc

browserify:
	@echo "Browserify-ing..."
	@yarn browserify ./index.js --node --bare -o ./index.bundle.js

babel-minify:
	@echo "Minifying..."
	@yarn babel-minify ./index.bundle.js --out-file ./index.min.js

finish:
	@echo "Finishing up..."
	@node ./make.js
