#!/usr/bin/make -f
SHELL=/usr/bin/env bash
## PHONY (auto-collect all targets; always run as task runner)
.PHONY: $(shell grep -oE '^[a-zA-Z0-9_-]+:[^=]' $(firstword $(MAKEFILE_LIST)) | sed 's/:.*//')
## var
BASE:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DATEID:=$(shell date +%Y%m%d%H%M%S)
## README
.DEFAULT_GOAL := readme
define README
--- Makefile Task List --- #COMMENT
endef
export README
readme: # @hide
	@echo ${README}
	@printf "\033[1;31m==== [Makefile] ====\033[0m\n"
	@grep -E '^[^#[:space:]].*:[[:space:]]*(#.*)?$$' Makefile | awk '/@hide$$/ {next} {sub(/#.*/, "\033[90m&\033[0m")}1'
	#@if [ -f other/Makefile ]; then echo; echo "[other/Makefile]"; grep -E '^[^#[:space:]].*:[[:space:]]*(#.*)?$$' other/Makefile; fi
serv: # ローカルサーバを起動する
	hugo server
build: # 静的ファイルを出力する
	hugo --minify
clean: # 出力とキャッシュを削除する
	rm -rf public resources .hugo_build.lock