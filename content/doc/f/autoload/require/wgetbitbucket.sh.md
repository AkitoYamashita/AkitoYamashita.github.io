# wgetbitbucket.sh

```bash
#!/bin/bash
wgetbitbucket(){
  if [ $# -ne 2 ]; then
    echo "Require bitbucket [user],[repo]"
  else
    wget --user=$1 --ask-password https://bitbucket.org/$1/$2/get/main.zip -O main.zip
  fi
}
```
