# gitconfig.sh

```bash
#!/bin/bash
gitconfig(){
  if [ $# -ne 2 ]; then
    echo "Require [name],[email]"
  else
    git config --local user.name $1
    git config --local user.email $2
    git config --local push.default current
  fi
}
```
