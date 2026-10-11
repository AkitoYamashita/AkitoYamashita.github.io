# ENV

```text
#!/bin/bash

## general
export LANG=ja_JP.UTF-8
export LANGUAGE=ja
export EDITOR=vim

## disable
PRESS_KEY=" echo 'Press any key to continue...'; read -k1 -s"
alias emacs="echo 'DisabledCommand:emacs'; ${PRESS_KEY}"

## hub
export PATH="$PATH:$HOME/hub"

## bin
export BIN="${HOME}/bin"
export LOCAL_BIN="${HOME}/.local/bin"
export PATH="$PATH:$BIN:$LOCAL_BIN"

## gcloud cli
export PATH="$PATH:$HOME/google-cloud-sdk/bin"

## VSCode拡張(Copilot)が注入するGITHUB_TOKENは権限不足でmise等が401になるため捨てる
[ -n "$VSCODE_INJECTION" ] && unset GITHUB_TOKEN

## mise
if command -v mise >/dev/null 2>&1; then
	case "$OS" in
		WINDOWS) export PATH="$HOME/AppData/Local/mise/shims:$PATH" ;;
		*) eval "$(mise activate $SH)" ;;
	esac
fi

## anyenv
if [ -d "$HOME/.anyenv/bin" ]; then
	export ANYENV_ROOT="$HOME/.anyenv"
	export PATH="$ANYENV_ROOT/bin:$PATH"
	if command -v anyenv 1>/dev/null 2>&1; then
    eval "$(anyenv init -)"
  fi
fi

## java
##/usr/lib/jvm/default-runtime/
export JAVA_HOME=/usr/java/default
export PATH=$PATH:$JAVA_HOME/bin
export JDK_HOME=$JAVA_HOME
export INSTALL4J_JAVA_HOME=$JAVA_HOME
## intellij idea
export IDEA_HOME=$JAVA_HOME
export IDEA_JDK=$JAVA_HOME
## maven
export M2_HOME=/opt/maven
export PATH=$PATH:$M2_HOME/bin
## glassfish
export AS_JAVA=/usr/java/default
## tomcat
export CATALINA_HOME=/opt/tomcat/
export TOMCAT_HOME=$CATALINA_HOME

## android
#export ANDROID_HOME=/mnt/c/Users/aktym/AppData/Local/Android/Sdk
#export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

## scala
export SCALA_HOME=/usr/share/scala
export PATH=$PATH:$SCALA_HOME/bin

## python
export PYTHONPATH=/j11/python:$PYTHONPATH
export PATH=$PATH:$HOME/.local/bin

## php
export PATH=/usr/local/src/php/bin/:$PATH

## golang(for 1.11 later)
# export GOROOT="/usr/local/go"
export GOROOT="/opt/homebrew/opt/go/libexec"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
#export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin

## c++
## qt
#export QTDIR=~/Qt
export QT_DIR=/opt/Qt
export QT_VERSION=5.11.1
export QT_QMAKE_DIR=$QT_DIR/$QT_VERSION/gcc_64/bin
export PATH=$PATH:$QT_QMAKE_DIR

## rust
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH=$PATH:~/.cargo/bin
  source "$HOME/.cargo/env"
fi

## perl
##Deadfish
# export PERL5LIB=$HOME/husky/oceans/deadfish

## nodejs
## nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

## ruby
#GEM_HOME=$(ls -t -U | ruby -e 'puts Gem.user_dir')
#GEM_PATH=$GEM_HOME
#export PATH=$PATH:$GEM_HOME/bin
#export PATH=$PATH:$HOME/.gem/ruby/2.4.0/bin

## dart
export PATH="$PATH":"$HOME/fvm/default/bin"
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true

## homebrew
### libpq(postgres)
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
```
