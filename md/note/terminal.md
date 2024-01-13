# Terminal

## TIPS

* コマンドの強制終了=>`ctrl+c`
* ターミナルの表示リセット=>`ctrl+l`
* ESCキーの代用=>`Ctrl+[`
* カーソルの位置から行頭までを削除=>`ctrl+u`
* カーソルの位置から行末までを削除=>`ctrl+k`
* シンボリックリンクの向き先変更=>`ln -nfs TARGET .`
* ワンライナーで設定書き換え=>`sed -i -e "s/^upload_max_filesize = 2M$/upload_max_filesize = 500M/g" /etc/php.ini`
* CURLでファイルダウンロードと権限付与=>`curl -sSLO https://path/to/f.sh && chmod +x f.sh`
* DOSやWSLを見やすくする=>[ColorTool](https://qiita.com/ysk_n/items/21d9e3fb8b8f22ab3476)
* Finder設定(隠しファイルの表示)=>`defaults write com.apple.finder AppleShowAllFiles true && killall Finder`
* ファイルバックアップ=>`cp -f file.txt file.txt.org`

## Bashテンプレート

```bash
#!/usr/bin/env bash
#!/bin/bash
BASE="$(dirname "$(readlink -f "${BASH_SOURCE:-0}")")"
DIRNAME="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)"
FILENAME="$(basename "${BASH_SOURCE:-0}")"
DATEID=$(date +%Y%m%d%H%M%S)
[ -e $BASE/_.sh ] && source $BASE/_.sh
cd $BASE
```

## Makefileテンプレート

```Makefile
#!/usr/bin/make -f
##
#SHELL=/bin/sh
#SHELL=/bin/bash
SHELL=/usr/bin/env bash
DIR:=$(realpath $(firstword $(MAKEFILE_LIST)))
BASE:=$(shell dirname ${DIR})
##
_readme:
  @echo '--- Makefile Task List ---'
  @grep '^[^#[:space:]|_][a-z|_]*:' Makefile
base:
  @echo ${BASE}
gip: # global ip
  curl ifconfig.io
```

## cargo-make(Makfile.toml)テンプレート

```toml
#Makefile.toml

[config]
skip_core_tasks = true

[tasks.bash]
script = [
'''
#!/usr/bin/env bash
echo "Hello, World!"
echo "args:"
echo "->@:${@}"
echo "->\$0:$0"
echo "->\$1:$1"
echo "->\$2:$2"
echo "->\$3:$3"
'''
]

[tasks.python]
script = [
'''
#!/usr/bin/env python3
print("Hello, World!")
'''
]
```

```bash
# 導入ワンライナー
CARGO_MAKE="0.37.6" && curl -sSLO https://github.com/sagiegurari/cargo-make/releases/download/0.37.6/cargo-make-v${CARGO_MAKE}-x86_64-unknown-linux-musl.zip && unzip cargo-make-v${CARGO_MAKE}-x86_64-unknown-linux-musl.zip && sudo cp -f cargo-make-v${CARGO_MAKE}-x86_64-unknown-linux-musl/cargo-make /usr/local/bin/ && rm -Rf cargo-make-v${CARGO_MAKE}-x86_64-unknown-linux-musl && rm -f cargo-make-v${CARGO_MAKE}-x86_64-unknown-linux-musl.zip && cargo-make --version
# 実行(`--option`のようなオプションは`cargo-make`自体のオプションと解釈されるので`--`を挟むことに注意)
makers bash -- --ARG1 --ARG2
makers python
```

## Anyenv導入

```bash
git clone https://github.com/anyenv/anyenv ~/.anyenv
exec $(SHELL) -l
anyenv install --init
anyenv install --list
anyenv install nodenv
anyenv install rbenv
anyenv install pyenv
```

PATHを通す

```bash
#vim ~/.zshrc
if [ -e "$HOME/.anyenv" ]
then
    export ANYENV_ROOT="$HOME/.anyenv"
    export PATH="$ANYENV_ROOT/bin:$PATH"
    if command -v anyenv 1>/dev/null 2>&1
    then
        eval "$(anyenv init -)"
    fi
fi
```

## Mustache(Bash)の[Mo](https://github.com/tests-always-included/mo)導入

```bash
[ ! -e "./mo" ] && curl -sSLO https://raw.githubusercontent.com/tests-always-included/mo/master/mo && chmod 744 "./mo"
echo '{{NAME}}:["{{MSG}}"]' >> tmp.mo && NAME=MO MSG=Hello,Mo! ./mo tmp.mo && rm -f ./tmp.mo
```

## tmux

```bash
#!/usr/bin/env bash
#tmux2
function tmux2() {
  if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
    tmux new-session -s s1 -n w1\; \
      split-window -t w1.0 -v\; \
      resize-pane -t w1.0 -U 99\; \
      resize-pane -t w1.0 -D 4\; \
      send-keys -t w1.0 "watch -n 2 free -m" C-m \; \
      send-keys -t w1.1 "clear" C-m \; \
      select-pane -t w1.1 \;\
      &> /dev/null
  fi
}
tmux2 "$@"
```

```bash
#!/usr/bin/env bash
#tmux3
function tmux3() {
  if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
    tmux new-session -s s1 -n w1\; \
      split-window -t w1.0 -v\; \
      split-window -t w1.0 -h\; \
      resize-pane -t w1.0 -U 99\; \
      resize-pane -t w1.0 -D 6\; \
      send-keys -t w1.0 "clear" C-m \; \
      send-keys -t w1.1 "clear" C-m \; \
      send-keys -t w1.2 "clear" C-m \; \
      select-pane -t w1.2 \;\
      &> /dev/null
  fi
}
tmux3 "$@"
```

```bash
#!/usr/bin/env bash
# tmux4
function tmux4() {
  if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
    tmux new-session -s s1 -n w1\; \
      split-window -t w1.0 -v\; \
      split-window -t w1.0 -h\; \
      split-window -t w1.2 -h\; \
      resize-pane -t w1.0 -U 99\; \
      resize-pane -t w1.0 -D 6\; \
      send-keys -t w1.0 "clear" C-m \; \
      send-keys -t w1.1 "clear" C-m \; \
      send-keys -t w1.2 "clear" C-m \; \
      send-keys -t w1.3 "clear" C-m \; \
      select-pane -t w1.0 \;\
      &> /dev/null
  fi
}
tmux4 "$@"
```
