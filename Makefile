#!/usr/bin/make -f
##
#SHELL=/bin/sh
#SHELL=/bin/bash
SHELL=/usr/bin/env bash
DIR:=$(realpath $(firstword $(MAKEFILE_LIST)))
BASE:=$(shell dirname ${DIR})
GITHUB_PAGES:="https://AkitoYamashita.github.io/"
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
clean: # cache delete
	rm -rf ./node_modules && npm ci
	rm -rf ./tmp 
	mkdir -p ./tmp/docs
	date > ./tmp/docs/.gitkeep
link: # recreate symbolic link
# 	## for public src files
# 	rm -f ./x/md/.vuepress/public/src && ln -s ./../../../src ./x/md/.vuepress/public/src
# 	## for src markdown pages
# 	rm -f ./x/md/src && ln -s ./../src ./x/md/src 
	## for public chezmoi files
	rm -f ./markdown/.vuepress/public/chezmoi && ln -s ./../../chezmoi ./markdown/.vuepress/public/chezmoi
dev:link # dev mode server
	./node_modules/vuepress/bin/vuepress.js dev markdown --debug
serve:link # release mode server
	./node_modules/vuepress/bin/vuepress.js dev markdown --host 0.0.0.0 --no-watch --clean-cache --clean-temp 
build:link # release build
	./node_modules/vuepress/bin/vuepress.js build markdown --clean-cache --clean-temp 
versioning:
	echo "Build: $$(TZ='Asia/Tokyo' date '+%Y-%m-%d %H:%M:%S JST')" > markdown/.vuepress/public/version.txt
workflow:clean versioning build # call by github action
open: # site browse
	@curl -s ${GITHUB_PAGES}/version.txt
	@open ${GITHUB_PAGES}