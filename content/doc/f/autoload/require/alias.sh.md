# alias.sh

```bash
#!/usr/bin/env bash
alias ll='ls -alFh'
alias l='ls -cf'
# wrapper が存在する場合だけ make の alias を張る
if [ -x "$HOME/bin/make_wrapper" ]; then
  alias make="$HOME/bin/make_wrapper"
fi
alias watch='watch -d=permanent -n 5'
alias pss="ps --sort=start_time"
alias dimages="sudo docker images"
alias dps="sudo docker ps -a"
alias e="emacs -nw"
alias l='git log'
alias b='git branch'
alias d='git diff --color-words --staged'
#alias s='git status' ##simple
alias s='git status --untracked-files=all'
alias tmuxkillserver='tmux kill-server'
alias adb='/mnt/c/Users/aktym/AppData/Local/Android/Sdk/platform-tools/adb.exe'
alias emulator='/mnt/c/Users/aktym/AppData/Local/Android/Sdk/emulator/emulator.exe'
ks(){
  echo "Oops!"
}
mike(){
  echo "Nyan!"
}
cm(){
  ## cargo make aliase
  if [ -x ./makers ]; then
    ./makers "$@"
  elif command -v makers >/dev/null 2>&1; then
    makers "$@"
  else
    echo "makers not found (no ./makers and not in PATH)" >&2
    return 1
  fi
}
```
