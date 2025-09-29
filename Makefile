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
clean: # cache delete
	rm -rf ./node_modules && npm ci
	rm -rf ./.dist
config: # edit VuePress config file
	vim ./data/md/.vuepress/config.ts
link: # recreate symbolic link
	## for public static files
	rm -f ./data/md/.vuepress/public/src && ln -s ./../../../../src ./data/md/.vuepress/public/src
	## for src markdown pages
	rm -f ./data/md/src && ln -s ./../../src ./data/md/src 
dev:link # dev mode server
	./node_modules/vuepress/bin/vuepress.js dev data/md --debug
serve:link # release mode server
	./node_modules/vuepress/bin/vuepress.js dev data/md --host 0.0.0.0 --no-watch --clean-cache --clean-temp 
build:clean link # release build
	mkdir -p .dist
	date > .dist/.gitkeep
	./node_modules/vuepress/bin/vuepress.js build data/md --clean-cache --clean-temp 
versioning:
	echo "Build: $$(TZ='Asia/Tokyo' date '+%Y-%m-%d %H:%M:%S JST')" > data/md/.vuepress/public/version.txt
version:
	@curl -s https://AkitoYamashita.github.io/version.txt
workflows:versioning build # call by github action
