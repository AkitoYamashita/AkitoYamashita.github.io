# VuePress

## Overview

- 静的サイトジェネレータ(SSG)
- Markdownベース
- Front matterなどで拡張できる
- 比較的ユーザーが多い
- セットアップが容易
- スタンドアロン且つ、日本語での全文検索が行えるプラグインがある

## Setup

[V2公式GettingStarted](https://v2.vuepress.vuejs.org/guide/getting-started.html)

```bash
npm init
npm install -D vuepress@next
./node_modules/vuepress/bin/vuepress.js dev docs
```

## Config

- `./vuepress/config.ts`
  - defineUserConfig
- `./vuepress/client.ts`
  - defineClientConfig

## Plugin

- [external-link-icon](https://v2.vuepress.vuejs.org/reference/plugin/external-link-icon.html)
- [vuepress-plugin-search-pro](https://plugin-search-pro.vuejs.press/)
