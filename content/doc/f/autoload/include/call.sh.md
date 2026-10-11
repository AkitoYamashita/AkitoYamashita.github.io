# call.sh

```bash
#!/bin/bash
call(){
  if [ $# -ne 1 ]; then
    echo "Require [function]"
  else
    $1
  fi
}
```
