#!/usr/bin/make -f
SHELL=/usr/bin/env bash
DIR:=$(realpath $(firstword $(MAKEFILE_LIST)))
BASE:=$(shell dirname ${DIR})
GITHUB_PAGES:="https://AkitoYamashita.github.io/"
## サブディレクトリ（プロファイル
PROFILE?=hugo
.DEFAULT: # @hide
	@$(MAKE) --no-print-directory -C $(PROFILE) $@
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
workflow:clean init build versioning # call by github action
