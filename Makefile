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
config: # edit VuePress config file
	vim ./x/md/.vuepress/config.ts
reset:
	rm -rf ./node_modules ./package-lock.json && npm install
clean: # cache delete
	rm -rf ./node_modules && npm ci
	rm -rf ./tmp
	mkdir -p tmp
	date > ./tmp/.gitkeep
link: # recreate symbolic link
	## for public src files
	rm -f ./x/md/.vuepress/public/src && ln -s ./../../../src ./x/md/.vuepress/public/src
	## for src markdown pages
	rm -f ./x/md/src && ln -s ./../src ./x/md/src 
dev:link # dev mode server
	./node_modules/vuepress/bin/vuepress.js dev x/md --debug
serve:link # release mode server
	./node_modules/vuepress/bin/vuepress.js dev x/md --host 0.0.0.0 --no-watch --clean-cache --clean-temp 
build:chezmoi link # release build
	./node_modules/vuepress/bin/vuepress.js build x/md --clean-cache --clean-temp 
versioning:
	echo "Build: $$(TZ='Asia/Tokyo' date '+%Y-%m-%d %H:%M:%S JST')" > x/md/.vuepress/public/version.txt
version: # check version
	@curl -s https://AkitoYamashita.github.io/version.txt
workflow:clean versioning build # call by github action
chezmoi: # reclone AkitoYamashita/chezmoi
	@rm -rf vendor/chezmoi; git clone --depth=1 https://github.com/AkitoYamashita/chezmoi.git vendor/chezmoi
