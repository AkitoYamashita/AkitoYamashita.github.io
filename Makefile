#!/usr/bin/make -f
##
#SHELL=/bin/sh
#SHELL=/bin/bash
SHELL=/usr/bin/env bash
DIR:=$(realpath $(firstword $(MAKEFILE_LIST)))
BASE:=$(shell dirname ${DIR})
GITHUB_PAGES:="https://AkitoYamashita.github.io/"
OUTPUT:="${BASE}/tmp/docs"
##
#define README
## README
#endef
#export README
_readme:
	@echo '--- Makefile Task List ---'
	@grep '^[^#[:space:]|_][a-z|_]*:' Makefile
gip: # global ip
	curl checkip.amazonaws.com
base: # base path
	@echo ${BASE}
guide: # open guide page by WSL
	/mnt/c/Windows/explorer.exe https://v2.vuepress.vuejs.org/guide/
config: # edit VuePress config file
	vim ./markdown/.vuepress/config.ts
resinstall: # npm library reinstall
	rm -rf ./node_modules ./package-lock.json && npm install
init: # initialize
	mkdir -p ./tmp $(OUTPUT)
	touch ./tmp/.gitkeep $(OUTPUT)/.gitkeep
clean: # cache delete
	rm -rf ./node_modules && npm ci
	rm -rf ./tmp 
	$(MAKE) init
dev: # dev mode server
	./node_modules/vuepress/bin/vuepress.js dev markdown --debug
serve: # release mode server
	./node_modules/vuepress/bin/vuepress.js dev markdown --host 0.0.0.0 --no-watch --clean-cache --clean-temp 
build: # release build
	./node_modules/vuepress/bin/vuepress.js build markdown --clean-cache --clean-temp 
versioning:
	echo "Build: $$(TZ='Asia/Tokyo' date '+%Y-%m-%d %H:%M:%S JST')" > markdown/.vuepress/public/version.txt
workflow:clean init build versioning # call by github action
open: # site browse
	@curl -s ${GITHUB_PAGES}/version.txt
	@open ${GITHUB_PAGES}