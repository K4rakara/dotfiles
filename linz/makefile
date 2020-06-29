all:
	@echo "Compiling Linz..."
	@echo "Installing packages..."
	@yarn
	@echo "Compiling TypeScript..."
	@yarn tsc
	@echo "Browserify-ing..."
	@yarn browserify ./index.js --node --bare -o ./index.bundle.js
	@echo "Minifying..."
	@yarn babel-minify ./index.bundle.js --out-file ./index.min.js
	@echo "Finishing up..."
	@node ./make.js
	@chmod a+x ./linz
	@echo "Done!"