all:
	@luamin -f ./fshuf.lua > ./fshuf.min.lua; \
	lua ./make.lua; \
	chmod a+x ./fshuf; \

install:
	@bash ./install.sh global; \

install-local:
	@bash ./install.sh; \