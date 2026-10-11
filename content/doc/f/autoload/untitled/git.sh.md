# git.sh

```bash
#!/bin/bash
gitremoteadd(){
  if [ $# -ne 3 ]; then
    echo "require [host],[repo_user],[repo_name]" 1>&2
  else
    git remote add origin https://$1/$2/$3.git
  fi
}
sshtestgithub(){
  ssh -T git@github.com
}
sshtestbitbucket(){
  ssh -T git@bitbucket.org
}
gitcommitcount(){
  git log --oneline | wc -l
}
gitrowcount(){
  git ls-files | xargs -n1 git --no-pager blame -w | wc -l
}
githideandseek(){
  echo -n "Are you sure? [y]: "
  read ans
  case $ans in
  '' | y* | Y* )
    git filter-branch -f --index-filter '
    git rm -rf --cached --ignore-unmatch * 
    ' HEAD
    git filter-branch -f --index-filter '
    touch .hidden | git add .hidden 
    ' HEAD
    git reflog expire --expire=now --all
    git gc --aggressive --prune=now
    ;;
  * )
    ;;
  esac
}
gitoverride(){
  git checkout --orphan tmp
  git commit -m "override"
  git checkout -B main
  git branch -d tmp
  git push -f --set-upstream origin main
}
seturl(){
  git remote add     origin $1
  git remote set-url origin $1
}
gitshallow(){
  git clone --depth 1 $1
}
gitunshallow(){
  git fetch --unshallow
}
gitchangecommiter(){
  USERNAME=AkitoYamashita
  USEREMAIL=akt.ymst@gmail.com
  git filter-branch -f --env-filter "GIT_AUTHOR_NAME='${USERNAME}'; GIT_AUTHOR_EMAIL='${USEREMAIL}'; GIT_COMMITTER_NAME='${USERNAME}'; GIT_COMMITTER_EMAIL='${USEREMAIL}';" HEAD
}
gitrepositorymerge(){
if [ $# -ne 1 ]; then
  echo "require local target repository path" 1>&2
  echo "Ex) [~/repos/repo]" 1>&2
else
  REPO_URL=$1
  SUBDIR=$(basename $REPO_URL)
  git fetch $REPO_URL/.git refs/heads/main:refs/heads/$SUBDIR
  git filter-branch -f --tree-filter '
  [ -d ${SUBDIR} ] || mkdir -p ${SUBDIR};
  find . -mindepth 1 -maxdepth 1 ! -path ./${SUBDIR} | xargs -i{} mv -f {} ${SUBDIR}
  ' $SUBDIR
  git merge --allow-unrelated-histories --no-ff $SUBDIR
fi
}
gitchangecommitmessage(){
  MSG=${@:-"### private commit message ###"}
  git filter-branch --msg-filter "echo '${MSG}';" -f
}
creategithubgrasssvg(){
curl https://github.com/$1 | awk '/<svg.+class="js-calendar-graph-svg"/,/svg>/' | sed -e 's/<svg/<svg xmlns="http:\/\/www.w3.org\/2000\/svg"/' > $1.svg
}
getLastCommitMessage(){
  if [ $# -ne 3 ]; then
    echo "require [host],[user],[repository]"
  else
  HOST=$1
  USER=$2
  REPO=$3
  curl https://$HOST/$USER/$REPO \
   | sed -n -e "/<div class=\"commit-tease js-details-container Details\">/,/<\/div>/p" \
   | grep title \
   | awk '{print substr($0, index($0, ">"))}' \
   | awk '{sub("<.*", "");print $0;}' \
   | cut -c 2-
  fi
}
gitrmremotebranch(){
  if [ $# -ne 1 ]; then
    echo "Require [branch]"
  else
    git push --delete origin $1
  fi
}
getGithubPublicRepositoryViaAPI(){
  curl https://api.github.com/users/AkitoYamashita/repos
}
getGithubPrivateRepositoryViaAPI(){
  ACCESS_TOKEN=$1
  ORG=$2
  curl -u :${ACCESS_TOKEN} https://api.github.com/orgs/$ORG{}/repos
  curl -H 'Authorization: token ${ACCESS_TOKEN}' https://api.github.com/orgs/$ORG/repos
  curl 'https://api.github.com/orgs/${ORG}/repos?access_token=${ACCESS_TOKEN}'
}
gitcreateremotebranch(){
  if [ $# -ne 1 ]; then
    echo "Require [branch]"
  else
    git branch $1
    git checkout $1
    git branch --all
    git push origin main:$1
  fi
}
gitdeleteremotebranch(){
  if [ $# -ne 1 ]; then
    echo "Require [branch]"
  else
    git branch -d $1
	git push --delete origin $1
  fi
}
gitskip(){
  if [ $# -ne 1 ]; then
    echo "Require [filepath]"
  else
    git update-index --skip-worktree $1
  fi
}
gitskiprevert(){
  if [ $# -ne 1 ]; then
    echo "Require [filepath]"
  else
    git update-index --no-skip-worktree $1
  fi
}
gitskipcheck(){
  git ls-files -v | grep ^S
}
gitresethard(){
  git reset --hard origin/main
}
gitsubmoduleadd(){
  if [ $# -ne 3 ]; then
    echo "Require [RepoHost],[RepoUser],[RepoName]"
  else
    git submodule add https://$1/$2/$3.git $3
  fi
}
gitsubmoduleinit(){
  git submodule update --init --recursive
}
gitsubmoduleupdate(){
  git submodule foreach 'git pull origin main --allow-unrelated-histories'
}
```
