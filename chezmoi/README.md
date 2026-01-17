# chezmoi

This repository contains the source state for chezmoi.
Files under $HOME are treated as generated artifacts and are not versioned.

## install

```bash
// linux
sh -c "$(curl -fsLS get.chezmoi.io)"
//  mac
brew install chezmoi
// windows
curl -fsLS get.chezmoi.io | sh
```

## setup

```bash
mkdir -p ~/.local/share
// `hub install chezmoi` または
// `ln -s ~/hub/~/AkitoYamashita.github.io/chezmoi ~/.local/share/chezmoi`
chezmoi init https://github.com/AkitoYamashita/chezmoi && chezmoi apply
```

### utils

```bash
# 差分確認
chezmoi diff
# apply 予定のファイル一覧
chezmoi apply --dry-run
# source → destination の対応関係を見る
chezmoi managed
# 設定情報の出力(chezmoi.dataなど)
chezmoi data | jq '{data: .chezmoi.config.data, os: .chezmoi.os, hostname: .chezmoi.hostname}'
```
