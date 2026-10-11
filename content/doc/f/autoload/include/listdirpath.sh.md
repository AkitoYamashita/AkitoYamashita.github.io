# listdirpath.sh

```bash
#!/bin/bash
function listdirpath(){
 if [ $# -ne 1 ]; then
    echo "Require [Path]"
  else
    DLIST=();
  for dir in `\find $1 -mindepth 1 -maxdepth 1 -not -name ".*" -type d`; do
      DLIST+=("$dir")
    done
  fi
  for path in ${DLIST[@]}; do
    echo "${path##*/}"
    #echo $path
  done
}
```
