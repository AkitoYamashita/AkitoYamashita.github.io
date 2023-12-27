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
base:
	@echo ${BASE}
guide:
	/mnt/c/Windows/explorer.exe https://v2.vuepress.vuejs.org/guide/
install:
	npm install
dev:
	./node_modules/vuepress/bin/vuepress.js dev src --debug --config ./src/.vuepress/config.js
serve:
	./node_modules/vuepress/bin/vuepress.js dev src --host 0.0.0.0 --no-watch --clean-cache --clean-temp 
build:
	./node_modules/vuepress/bin/vuepress.js build src
config:
	vim ./src/.vuepress/config.js
gip: # global ip
	curl ifconfig.io
