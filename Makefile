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
	rm -f ./md/.vuepress/public/src
	ln -s ../../../f/src ./md/.vuepress/public/src 
	rm -f ./md/src
	ln -s ../f/src ./md/src 
dev:link
	./node_modules/vuepress/bin/vuepress.js dev md --debug --config ./md/.vuepress/config.ts
serve:link
	./node_modules/vuepress/bin/vuepress.js dev md --host 0.0.0.0 --no-watch --clean-cache --clean-temp 
build:clean link
	./node_modules/vuepress/bin/vuepress.js build md --clean-cache --clean-temp 
config:
	vim ./md/.vuepress/config.ts