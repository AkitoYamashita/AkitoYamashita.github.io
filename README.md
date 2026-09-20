# AkitoYamashita.github.io

<https://akitoyamashita.github.io/>

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/AkitoYamashita/AkitoYamashita.github.io)

## Hugo

[workflow-action (Hugo)](./.github/workflows/hugo.yml)

## Environment

### Local

- macOS: 15.7.4（24G517）
- Hugo: 0.166.0
- Go: 1.25.0
- Pagefind: 1.5.2

### GitHub Actions

- Ubuntu: 24.04
- Hugo: 0.166.0
- Go: 1.25.0
- Pagefind: 1.5.2

---

## 概要

個人的なメモや技術記事を残すためのサイト。

現在の構成は Hugo + GitHub Pages。

コンテンツはできるだけ単純な Markdown として維持。
特定の Static Site Generator やディレクトリ構成への依存は最小限。

## ルール

通常の記事ファイルは以下の形式。

    YYYYMMDDHHmm-name.md

例:

    202609210305-hugo-routing.md

先頭12桁を Content ID として扱い、URLにも使用。

    /202609210305/

Content ID は新規作成時の時刻を元に発行。
記事の作成日時・公開日時・更新日時・記事内で扱う出来事の日時とは無関係。

一度発行した Content ID は変更不可。
`name` やファイルの配置ディレクトリは変更可能。

目的は、タイトル・分類・ディレクトリ構成・Static Site Generator などを
後から変更した場合でも公開URLを維持すること。

日付のみの8桁IDは、記事の公開日や出来事の日付と混同しやすく、
同日に複数の記事を作成する場合にも不向き。

連番・UUID・Unix time なども候補だが、
採番状態の管理や外部ツールを必要とせず、人間がその場で発行できることを優先。
分単位の `YYYYMMDDHHmm` を Content ID として採用。

## サイト遍歴

個人サイト・ブログ・技術記事などを残す場所として、
これまで様々な仕組みを試行。

古いものは記録が残っておらず、時期や順序が不明なものを含む。
採用・試作・移行検討などの区別なし。
実際に候補として触れたものを記録。

### 自前運用・実装

- レンタルサーバー（HTML / PHP）
- nginx / Apache + HTML
- 自作Webサーバー（PHP / JavaScript / Go / Rust）
- Python + Markdown
- Bash + Pandoc

### サービス

- Hatena Blog
- Qiita

### CMS / SSG / Generator

- WordPress
- Ghost
- Jekyll
- Middleman
- Hexo
- Gatsby
- VuePress
- VuePress 2
- VitePress
- Docusaurus（2026）
- Hugo（2026-09〜）
- GitBook
- mdBook
- Netlify CMS
