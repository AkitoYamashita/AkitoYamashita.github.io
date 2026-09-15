#!/usr/bin/make -f
SHELL=/usr/bin/env bash
.PHONY: $(shell grep -oE '^[a-zA-Z0-9_-]+:' $(firstword $(MAKEFILE_LIST)) | tr -d ':')
## var
BASE:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DATEID:=$(shell date +%Y%m%d%H%M%S)
## tool version (mise.toml と揃えること)
HUGO_VERSION:=0.166.0
PAGEFIND_VERSION:=1.5.2
PORT:=8080
## local binary directory (gitignore 対象)
BIN:=$(BASE)/bin
export PATH:=$(BIN):$(PATH)
.DEFAULT_GOAL := readme
readme: # @hide
	@grep -E '^[^#[:space:]].*:[[:space:]]*(#.*)?$$' Makefile | awk '/@hide$$/ {next} {sub(/#.*/, "\033[90m&\033[0m")}1'
workflow: # Github Actions workflow
	setup clean init build versioning
setup: # hugo と pagefind を用意する（既にあれば何もしない）
	@$(MAKE) --no-print-directory setup-hugo
	@$(MAKE) --no-print-directory setup-pagefind
setup-hugo: # @hide
	@if hugo version >/dev/null 2>&1; then echo "hugo: already available ($$(hugo version | cut -d' ' -f2))"; \
	elif command -v mise >/dev/null 2>&1; then echo "hugo: installing via mise"; cd $(BASE) && mise install; \
	elif command -v brew >/dev/null 2>&1; then echo "hugo: installing via brew"; brew install hugo; \
	else echo "hugo: downloading binary"; $(MAKE) --no-print-directory dl-hugo; fi
setup-pagefind: # @hide
	@if pagefind --version >/dev/null 2>&1; then echo "pagefind: already available ($$(pagefind --version))"; \
	else echo "pagefind: downloading binary"; $(MAKE) --no-print-directory dl-pagefind; fi
dl-hugo: # @hide
	@mkdir -p $(BIN); os=$$(uname -s); arch=$$(uname -m); case "$$os-$$arch" in Linux-x86_64) f=hugo_extended_$(HUGO_VERSION)_linux-amd64.tar.gz ;; Linux-aarch64|Linux-arm64) f=hugo_extended_$(HUGO_VERSION)_linux-arm64.tar.gz ;; MINGW*|MSYS*|CYGWIN*) f=hugo_extended_$(HUGO_VERSION)_windows-amd64.zip ;; Darwin-*) echo "Darwin provides only .pkg; install mise or brew first" >&2; exit 1 ;; *) echo "unsupported: $$os-$$arch" >&2; exit 1 ;; esac; curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/$$f" -o /tmp/hugo.pkgfile; case "$$f" in *.zip) unzip -o -q /tmp/hugo.pkgfile -d $(BIN) ;; *) tar -xzf /tmp/hugo.pkgfile -C $(BIN) hugo ;; esac; rm -f /tmp/hugo.pkgfile; $(BIN)/hugo version
dl-pagefind: # @hide
	@mkdir -p $(BIN); os=$$(uname -s); arch=$$(uname -m); case "$$arch" in arm64|aarch64) a=aarch64 ;; *) a=x86_64 ;; esac; case "$$os" in Darwin) t=$$a-apple-darwin ;; Linux) t=$$a-unknown-linux-musl ;; MINGW*|MSYS*|CYGWIN*) t=$$a-pc-windows-msvc ;; *) echo "unsupported: $$os" >&2; exit 1 ;; esac; curl -fsSL "https://github.com/CloudCannon/pagefind/releases/download/v$(PAGEFIND_VERSION)/pagefind-v$(PAGEFIND_VERSION)-$$t.tar.gz" -o /tmp/pagefind.tar.gz; tar -xzf /tmp/pagefind.tar.gz -C $(BIN); rm -f /tmp/pagefind.tar.gz; $(BIN)/pagefind --version
##
clean: # 出力とキャッシュを削除する
	rm -rf public resources .hugo_build.lock
distclean: # bin配下のバイナリも含めて削除する
	rm -rf public resources .hugo_build.lock bin
build: # 静的ファイルを出力し、検索インデックスを作る
	hugo --minify && pagefind --site public
##
serv: # ローカルサーバを起動する
	hugo server --port $(PORT)
preview: # ビルドして pythonサーバでpublicディレクトリをプレビューする（検索の確認用）
	$(MAKE) --no-print-directory build && python3 -m http.server $(PORT) --directory public
versioning: # バージョンファイルを生成
	echo "Build: $$(TZ='Asia/Tokyo' date '+%Y-%m-%d %H:%M:%S JST')" > ./static/version.txt
version: # site version browse
	@curl -s ${GITHUB_PAGES}/version.txt
	@open ${GITHUB_PAGES}