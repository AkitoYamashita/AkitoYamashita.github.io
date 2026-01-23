#!/usr/bin/make -f
SHELL=/usr/bin/env bash
DIR:=$(realpath $(firstword $(MAKEFILE_LIST)))
BASE:=$(shell dirname ${DIR})
GITHUB_PAGES:="https://AkitoYamashita.github.io/"
OUTPUT:="${BASE}/build"
##
#define README
## README
#endef
#export README
_readme:
	@echo '--- Makefile Task List ---'
	@grep '^[^#[:space:]|_][a-z|_]*:' Makefile
resinstall: # npm library reinstall
	rm -rf ./node_modules ./package-lock.json && npm install
init: # initialize
	mkdir -p ./tmp $(OUTPUT)
	touch ./tmp/.gitkeep $(OUTPUT)/.gitkeep
clean: # cache delete
	rm -rf ./node_modules && npm ci
	rm -rf $(OUTPUT) ./tmp 
	$(MAKE) init
build: # site build
	node ./node_modules/@docusaurus/core/bin/docusaurus.mjs build
serve: # site serve
	node ./node_modules/@docusaurus/core/bin/docusaurus.mjs serve
versioning:
	echo "Build: $$(TZ='Asia/Tokyo' date '+%Y-%m-%d %H:%M:%S JST')" > $(OUTPUT)/version.txt
workflow:clean versioning build # call by github action
open: # site browse
	@curl -s ${GITHUB_PAGES}/version.txt
	@open ${GITHUB_PAGES}