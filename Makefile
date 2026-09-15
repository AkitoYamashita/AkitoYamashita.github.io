#!/usr/bin/make -f
SHELL=/usr/bin/env bash
DIR:=$(realpath $(firstword $(MAKEFILE_LIST)))
BASE:=$(shell dirname ${DIR})
GITHUB_PAGES:="https://AkitoYamashita.github.io/"
## サブディレクトリ（プロファイル
PROFILE?=hugo
.DEFAULT: # @hide
	@$(MAKE) --no-print-directory -C $(PROFILE) $@
readme: # @hide
	@echo ${README}
	@printf "\033[1;31m==== [Makefile] ====\033[0m\n"
	@grep -E '^[^#[:space:]].*:[[:space:]]*(#.*)?$$' Makefile | awk '/@hide$$/ {next} {sub(/#.*/, "\033[90m&\033[0m")}1'
	@printf "\033[1;31m==== [$(PROFILE)/Makefile] ====\033[0m\n"
	@$(MAKE) --no-print-directory -C $(PROFILE) readme
gip: # global ip
	curl checkip.amazonaws.com
base: # base path
	@echo ${BASE}
workflow: # call makefile in profile
	@$(MAKE) --no-print-directory -C $(PROFILE) workflow
