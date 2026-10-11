# load.sh

```bash
#!/bin/bash
function load(){
  if [ $# -ne 1 ]; then
    echo "Require [path]"
  else
    if [ -f $1 ]; then source $1; fi
  fi
}
```
