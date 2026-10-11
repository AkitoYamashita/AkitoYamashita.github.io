# SHRC

```text
#!/usr/bin/env bash
#return 2> /dev/null; exit


## Minimal Functions
hr(){ C=${1--}; n=$(tput cols); while [ $((n-=1)) -ge 0 ]; do printf %s "$C"; done; printf '\n'; }
aligncenter(){ c=$(tput cols); m=$1; l=$(printf %s "$m"|wc -m); printf "%*s\n" $(((c+l)/2)) "$m"; }


## OS Check
if [ "$(uname)" = "Darwin" ]; then
	OS='MAC'
	## brew
	export PATH="$PATH":"$HOME/.pub-cache/bin"
elif [ "$(uname -s | cut -c1-5)" = "Linux" ]; then
	OS='LINUX'
elif [ "$(uname -s | cut -c1-5)" = "MINGW" ] || [ "$(uname -s | cut -c1-4)" = "MSYS" ] || [ "$(uname -s | cut -c1-6)" = "CYGWIN" ]; then
	OS='WINDOWS'
else
	echo "NoSupportOS:$(uname -a)"
	return 2>/dev/null || exit 1
fi

## Shell Check
if [ -n "$ZSH_VERSION" ]; then
	SH='zsh'
elif [ -n "$BASH_VERSION" ]; then
	SH='bash'
else
	SH='sh'
fi


## Interactive Check
[ -n "${PS1:-}" ] && echo "InteractiveShell" &>/dev/null


## Base Directory v6
SCRIPT_PATH="${BASH_SOURCE[0]:-${(%):-%x}}"
while [ -h "$SCRIPT_PATH" ]; do
  DIR="$(cd -P "$(dirname "$SCRIPT_PATH")" && pwd)"
  SCRIPT_PATH="$(readlink "$SCRIPT_PATH")"
  case "$SCRIPT_PATH" in
    /*) ;; # absolute path, nothing to fix
    *) SCRIPT_PATH="$DIR/$SCRIPT_PATH" ;; # relative symlink
  esac
done
BASE="$(cd -P "$(dirname "$SCRIPT_PATH")" && pwd)"

## Hub
HUB="$HOME/hub"

## F Commands
F_CMDS="help,loaded"
f(){
  case "$1" in
    help)   echo "usage: f [subcommand]"; printf '%s\n' "$F_CMDS" | tr ',' '\n' ;;
    loaded) printf '%s\n' "$F_LOADED" | tr ',' '\n' | awk '{printf("%3d %s\n", NR, $0)}' ;;
    "")     hr; aligncenter "F"; hr ;;
    *)      echo "unknown: $1";;
  esac
}

## Load Script for F
F_LOADED="$SCRIPT_PATH" # loaded file paths
f_load(){
  [ $# -ne 1 ] && { echo "Require [PATH]"; return 1; }
  SRC_PATH="$1"
  if [ -f "$SRC_PATH" ]; then
    . "$SRC_PATH"; F_LOADED="$F_LOADED,$SRC_PATH"; return
  fi
  DIR="$SRC_PATH/autoload"
  if [ -d "$DIR" ]; then
    for FILE in $(find "$DIR" -type f -name "*.sh"); do
      RELATIVE="${FILE#$DIR/}"
      ABSOLUTE="$FILE"
      # echo "RELATIVE: $RELATIVE"
      # echo "ABSOLUTE: $ABSOLUTE"
      . "$ABSOLUTE"
      F_LOADED="$F_LOADED,$ABSOLUTE"
    done
  else
    echo "WARN: $DIR not found, skipping autoload"
  fi
}
f_load "${BASE}"

## Load ENV
f_load "$BASE/ENV"

## Load hub token.sh
f_load "$HUB/src/struct/token.sh"

## Root Check
if [ "${EUID:-${UID}}" -eq 0 ]; then
  ## Root
  if [ -n "$BASH_VERSION" ]; then
    # bash root prompt
    PS1='[\u@\h \W]\$ '
  elif [ -n "$ZSH_VERSION" ]; then
    # zsh root prompt
    PROMPT='%n@%m %1~# '
  fi
  hr "#"
  export EDITOR=nano
else
  ## User
  if [ -n "$BASH_VERSION" ]; then
    # bash user prompt
    #PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$' ## <- default
    #PS1='\e[1;32m\u@\h\e[0m:\e[1;34m\w\e[0m\$' ## <- simple
    PS1='\u:\w\$ ' ## <- minimal
  elif [ -n "$ZSH_VERSION" ]; then
    # zsh user prompt
    PROMPT='%F{green}%n%f:%F{blue}%~%f$ '
  fi
  hr "$"
  export EDITOR=vim
fi


## Tmux AutoStart
#if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
#  tmux_count=$(ps -ax | grep '[t]mux' | wc -l)
#  if [ $tmux_count = 0 ]; then
#    tmux -u new-session &>/dev/null
#  elif [ $tmux_count = 1 ]; then
#    tmux -u attach &>/dev/null
#  fi
#fi


# Makefile target completion for bash 
if [ -n "$BASH_VERSION" ]; then
  _make_targets_list() {
    make -qp 2>/dev/null | awk -F: '/^[a-zA-Z0-9][^:#=]*:/{print $1}' | sort -u
  }
  complete -W "$(_make_targets_list)" make
fi
## Makefile target completion for zsh 
#if [ -n "$ZSH_VERSION" ]; then
#  # TODO
#fi


## Complete
return 2> /dev/null; exit
```
