# wgetgithub.sh

```bash
#!/bin/bash
wgetgithub(){
  if [ $# -ne 2 ]; then
    echo "Require bitbucket [user],[repo]"
  else
    wget --no-check-certificate https://github.com/$1/$2/archive/main.zip -O main.zip
  fi
}
```
