# Git

Reference

## SSH

### RSAkey

```bash
ssh-keygen -t rsa -C ""
mv id_rsa authorized_keys
```

### ManualConnect

`sudo ssh username@hostname -p 22 -i ~/.ssh/host/github.com/id_rsa`

### Permission

```bash
chmod 0700 ~/.ssh -R
chmod 0644 ~/.ssh/config
chmod 0600 ~/.ssh/host/ -R
```

### Test

```bash
ssh -T git@github.com
ssh -T git@bitbucket.org
```

### Config

```bash
git config --global user.name TransAssist
git config --global user.email x.assists@gmail.com
```

### Reset

```bash
git init
git remote add     origin git@github.com:username/repo.git
git remote set-url origin git@bitbucket.org:username/repo.git
git fetch origin
git reset --hard origin/master
```

### Commit

```bash
git commit -m "initialize"
git push --set-upstream origin master
```

### Push(Force)

```bash
git push --force origin master
git push https://username:password@github.com/user/repository.git --all
```

### RewritingHistory

```bash
git checkout master
git filter-branch -f --tree-filter 'git rm -rf --cached --ignore-unmatch [directory]/' HEAD
git gc
```

## Tips

### AuthorChange

```bash
USERNAME="username"
USEREMAIL="useremail"
git filter-branch -f --env-filter "GIT_AUTHOR_NAME='${USERNAME}'; GIT_AUTHOR_EMAIL='${USEREMAIL}'; GIT_COMMITTER_NAME='${USERNAME}'; GIT_COMMITTER_EMAIL='${USEREMAIL}';" HEAD
```

### GitRestore

```bash
git reset HEAD ./.gitignore
```

### ResetHistory

```bash
git checkout --orphan tmp
git commit -m "override"
git checkout -B master
git branch -d tmp
git push -f
```

### Github wget repository

`wget --no-check-certificate https://github.com/username/repo/archive/master.zip`

### Bitbucket.org wget repository

```bash
USER="user"
PASS="pass"
TEAM="team"
REPO="repo"
TARGET="README.md"
wget --user=$USER --ask-password https://bitbucket.org/$TEAM/$REPO/raw/master/$TARGET
wget --user=$USER --password=$PASS https://bitbucket.org/$TEAM/$REPO/get/master.zip

curl --digest --user username:password https://bitbucket.org/username/repo/get/master.zip -o master.zip
```

### UpdateRepositoryName

.git/config

```bash
[remote "origin"]
url = git@github.com:username/newrepo.git
```
