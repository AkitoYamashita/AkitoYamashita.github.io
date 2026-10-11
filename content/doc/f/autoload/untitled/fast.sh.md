# fast.sh

```bash
#!/bin/bash
fadd(){
  git add .
}
fcommit(){
  MSG=${@:-"fast commit"}
  git commit --allow-empty -m "$MSG"
  git push --set-upstream origin main
}
facommit(){
  fadd
  fcommit
}
fconfig(){
  git config --local user.name ${1:-"AkitoYamashita"}
  git config --local user.email ${2:-"akt.ymst@gmail.com"}
}
fcount(){
  git shortlog -s -n
}
fclone(){
  if [ $# -ne 3 ]; then
    echo "Require[domain],[repouser],[reponame]"
  else
    git clone git@$1:$2/$3.git
  fi
}
fmerge(){
  git merge --allow-unrelated-histories origin/main
}
finitshare(){
  git init --bare --shared
}
fremote(){
  if [ $# -ne 3 ]; then
    echo "Require[domain],[repouser],[reponame]"
  else
    git remote add origin git@$1:$2/$3.git
  fi
}
fresethard(){
  git reset --hard origin/main
}
fresetsoft(){
  git reset --soft HEAD^
}
frelease(){
  if [ $# -ne 1 ]; then
    echo "Require [tag]"
  else
    git tag -d $1
    git push origin :$1
    git commit --allow-empty -m "Release $1"
    git tag $1
    git push --set-upstream origin $1
  fi
}
fpush(){
  git push --set-upstream origin main
}
fpull(){
  git pull origin main
}
ffetch(){
  git fetch origin
}
fssh(){
  if [ $# -ne 4 ]; then
    echo "Require [user],[host],[port],[identify_file]"
  else
    USER=$1
    HOST=$2
    PORT=$3
    IDENTITY_FILE=$4
    ssh $USER@$HOST -p $PORT -i $IDENTITY_FILE
  fi
}
fless(){
  if [ $# -ne 1 ]; then
    echo "Require [filepath]"
  else
    less $1 | grep -v "^\s*$" | grep -v "^\s*#"
  fi
}
```
