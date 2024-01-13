#!/usr/bin/make -f
##
#SHELL=/bin/sh
#SHELL=/bin/bash
SHELL=/usr/bin/env bash
DIR:=$(realpath $(firstword $(MAKEFILE_LIST)))
BASE:=$(shell dirname ${DIR})
##
#define README
## README
#endef
#export README
_readme:
	@echo '--- Makefile Task List ---'
	@grep '^[^#[:space:]|_][a-z|_]*:' Makefile
gip: # global ip
	curl ifconfig.io
base: # base path
	@echo ${BASE}
guide: # open guide page by WSL
	/mnt/c/Windows/explorer.exe https://v2.vuepress.vuejs.org/guide/
clean:
	rm -rf ./node_modules && npm ci
link:
	## for public static files
	rm -f ./md/.vuepress/public/src && ln -s ./../../../src ./md/.vuepress/public/src
	## for src markdown pages
	rm -f ./md/src && ln -s ./../src ./md/src 
build:clean link # release build
	./node_modules/vuepress/bin/vuepress.js build md --clean-cache --clean-temp 
workflows:build # call by github action
config:
	vim ./md/.vuepress/config.ts
dev:link
	./node_modules/vuepress/bin/vuepress.js dev md --debug --config ./md/.vuepress/config.ts
serve:link
	./node_modules/vuepress/bin/vuepress.js dev md --host 0.0.0.0 --no-watch --clean-cache --clean-temp 