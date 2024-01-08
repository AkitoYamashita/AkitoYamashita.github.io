# Bash

## 逆引きTIPS

* コマンドの強制終了=>`ctrl+c`
* ターミナルの表示リセット=>`ctrl+l`
* ESCキーの代用=>`Ctrl+[`
* カーソルの位置から行頭までを削除=>`ctrl+u`
* カーソルの位置から行末までを削除=>`ctrl+k`
* シンボリックリンクの向き先変更=>`ln -nfs TARGET .`
* ワンライナーで設定書き換え=>`sed -i -e "s/^upload_max_filesize = 2M$/upload_max_filesize = 500M/g" /etc/php.ini`
* CURLでファイルダウンロードと権限付与=>`curl -sSLO https://path/to/f.sh && chmod +x f.sh`
  * Moをワンライナーで準備=>`[ ! -e "$(dirname "$(readlink -f "${BASH_SOURCE:-0}")")/mo" ] && curl -sSLO https://raw.githubusercontent.com/tests-always-included/mo/master/mo && chmod 744 mo`
* DOSやWSLを見やすくする=>[ColorTool](https://qiita.com/ysk_n/items/21d9e3fb8b8f22ab3476)

## Anyenv導入

```bash
git clone https://github.com/anyenv/anyenv ~/.anyenv
exec $(SHELL) -l
anyenv install --init
anyenv install --list
anyenv install nodenv
anyenv install rbenv
anyenv install pyenv
```

PATHを通す

```bash
#vim ~/.zshrc
if [ -e "$HOME/.anyenv" ]
then
    export ANYENV_ROOT="$HOME/.anyenv"
    export PATH="$ANYENV_ROOT/bin:$PATH"
    if command -v anyenv 1>/dev/null 2>&1
    then
        eval "$(anyenv init -)"
    fi
fi
```
