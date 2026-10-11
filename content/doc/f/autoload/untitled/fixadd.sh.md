# fixadd.sh

```bash
#!/bin/bash
fixadd(){
  if [ $# -ne 2 ]; then
    echo "require [FILE],\"[LINE]\"" 1>&2
  else
    FILE=$1
    LINE=$2
    grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  fi
}
disablealert(){
  touch ~/.inputrc
  fixadd ~/.inputrc "set bell-style none"
  touch ~/.vimrc
	fixadd ~/.vimrc "set visualbell t_vb="
}
```
