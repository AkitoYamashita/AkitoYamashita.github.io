# listfilepath.sh

```bash
#!/bin/bash
function listfilepath(){
 if [ $# -ne 1 ]; then
    echo "Require [Path]"
  else
    FLIST=();
  for file in `\find $1 -maxdepth 1 -not -name '.*' -type f`; do
      FLIST+=("$file")
    done
  fi
  for path in ${FLIST[@]}; do
    #echo "${path##*/}"
    echo $path
  done
}
```
