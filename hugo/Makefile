#!/usr/bin/make -f
SHELL=/usr/bin/env bash
.PHONY: $(shell grep -oE '^[a-zA-Z0-9_-]+:' $(firstword $(MAKEFILE_LIST)) | tr -d ':')
## var
BASE:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DATEID:=$(shell date +%Y%m%d%H%M%S)
GITHUB_PAGES:="https://AkitoYamashita.github.io/"
## Hugo
HUGO_VERSION:=0.166.0
PAGEFIND_VERSION:=1.5.2
PORT:=8080
CONTENT:=../markdown
PERMALINKS:=.permalinks.toml
## local binary directory (gitignore 対象)
BIN:=$(BASE)/bin
export PATH:=$(BIN):$(PATH)
.DEFAULT_GOAL := readme
readme: # @hide
	@grep -E '^[[:alnum:]_-]+:[^=].*' Makefile | awk '/# @hide$$/ {next} {sub(/#.*/, "\033[90m&\033[0m")}1'
workflow: setup clean versioning build # Github Actions workflow
##
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
	rm -rf public resources .hugo_build.lock $(PERMALINKS)
distclean: # bin配下のバイナリも含めて削除する
	rm -rf public resources .hugo_build.lock bin $(PERMALINKS)
check: # Markdown の命名規則と Content ID の重複を確認
	@bad=$$(find $(CONTENT)/log $(CONTENT)/note -type f -name '*.md' ! -name '_index.md' | grep -Ev '/[0-9]{12}-.+\.md$$' || true); \
	if [ -n "$$bad" ]; then echo "invalid filename:"; echo "$$bad"; exit 1; fi
	@dup=$$(find $(CONTENT)/log $(CONTENT)/note -type f -name '[0-9]*-*.md' -exec basename {} \; | cut -c1-12 | sort | uniq -d); \
	if [ -n "$$dup" ]; then echo "duplicate Content ID:"; echo "$$dup"; exit 1; fi
permalinks: check # Content ID から Hugo 用 permalink 設定を生成
	@: > $(PERMALINKS)
	@find $(CONTENT)/log $(CONTENT)/note -type f -name '[0-9]*-*.md' | sort | while read f; do \
		id=$$(basename "$$f" | cut -c1-12); \
		path=$${f#$(CONTENT)}; \
		path=$${path%.md}; \
		printf '[[permalinks]]\npattern = "/%s/"\n[permalinks.target]\npath = "%s"\n\n' "$$id" "$$path" >> $(PERMALINKS); \
	done
build: permalinks # 静的ファイルを出力し、検索インデックスを作る
	hugo --minify --config hugo.toml,$(PERMALINKS) && pagefind --site public
##
serv: permalinks # ローカルサーバを起動する
	hugo server --config hugo.toml,$(PERMALINKS) --port $(PORT)
preview: # ビルドして pythonサーバでpublicディレクトリをプレビューする（検索の確認用）
	$(MAKE) --no-print-directory build && python3 -m http.server $(PORT) --directory public
versioning: # バージョンファイルを生成
	echo "Build: $$(TZ='Asia/Tokyo' date '+%Y-%m-%d %H:%M:%S JST')" > ./static/version.txt
show: # site version browse
	@curl -s ${GITHUB_PAGES}/version.txt
	@open ${GITHUB_PAGES}
