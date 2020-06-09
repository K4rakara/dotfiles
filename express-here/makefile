
all:
	@echo "Compiling express-here..."; \
	echo "Creating directories..."; \
	mkdir -p ./tmp/tsc; \
	mkdir -p ./tmp/browserify; \
	mkdir -p ./tmp/babel-minify; \
	echo "Compiling TypeScript..."; \
	yarn tsc; \
	echo "Browserify-ing..."; \
	yarn browserify ./tmp/tsc/index.js --node -o ./tmp/browserify/index.js; \
	echo "Minifying..."; \
	yarn babel-minify ./tmp/browserify/index.js --out-file ./tmp/babel-minify/index.js; \
	echo "Finishing..."; \
	node ./make.js; \
	echo "Cleaning up..."; \
	rm -rf ./tmp; \

install:
	@bash ./install.sh global; \

install-local:
	@bash ./install.sh; \
