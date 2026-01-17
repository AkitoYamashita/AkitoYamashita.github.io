# Markdown

>Markdownは、文書を記述するための軽量マークアップ言語のひとつである。本来はプレーンテキスト形式で手軽に書いた文書からHTMLを生成するために開発されたものである。

※フレーバーが多いため、オリジナル記法とGithubMrkdownなどの独自記法、推奨されているルールを認識した上で使うようにしないと利用ライブラリやプラットフォームで差異が出るので注意

## Reference

* [DaringFireball:MarkdownSyntax](https://daringfireball.net/projects/markdown/syntax)
* [MarkdownLint](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)

## 全般

* 連続する空白行は1つにする(MD012)
* 最後の行は改行文字で終える(MD047)
* 文末に不要な空白を入れない≠改行のためのスペース(MD009)
* HTMLを書かない(MD033)

## テキスト

半角スペースを連続で使用しない  

`_` か `*` で囲むとemタグ(*強調要素*)≠イタリック体に変換  
`__` か `**` で囲むとstrongタグ(**重要性要素**)≠太字に変換  

* 文字の長さが80文字を超える場合は改行する(MD013)
* セクションを区切るためにヘッダーの代わりとして強調を使わない(MD036)
* 強調マーカーの前後にスペースを入れない(MD037)

## リンク

* 構文を逆にしない(MD011)
* URLをそのまま記述する場合は`<`と`>`で囲む(MD034)
* リンクテキスト前後に空白を入れない(MD039)
* 空リンクを指定しない(MD042)

```markdown
<https://google.com/>
![text](url)
```

## 画像

* 画像設定する場合は代替テキスト(ALT)設定を行う(MD045)

```markdown
![alt](url)
![favicon](/favicon.ico)
```

## ヘッダー

`#`の数に応じてh1\~h6を出力  

* 見出しはh1->h2->h3のように一つずつ(MD001)  
* 同じドキュメント内で異なるヘッダースタイル(Ex.`# Header #`)を混同しない(MD003)  
* `#`の前には何も入れず、`#`の後は半角スペースを一つ入れる(MD010,MD018,MD019,MD020,MD021,MD023)  
* 同一のテキストを複数のヘッダーに指定しない(MD024)
* ヘッダーの前後は空白行を入れる(MD022)  
* 一行目にだけ最上位のヘッダーを使う(MD002,MD025,MD041)
* ヘッダーテキストの最後に`.,;:!。，；：！`の文字を使わない(MD026)

```markdown
# Header1

## Header2

### Header3

#### Header4

##### Header5

###### Header6
```

## リスト

* 同階層のリスト記号は一致させる(MD004)
* リストの初めの要素にインデントを付けない(MD006)
* 階層のインデントは半角スペースx2で揃える(MD005,MD007,MD010)
* 番号リストのプレフィックスは1からの番順にする(MD029)
* リストのプレフィックス後は半角スペースx1(MD030)
* 空白行を前後に入れる(MD032)

```markdown
* Item 1
  + Item 2
  + Item 3
    - Item 4
    - Item 5
    - Item 6

1. Item A
2. Item B
3. Item C
```

## コードスパン/ブロック

* シェルコマンドなどのコードブロックで`$`を含めない(MD014)
* 空白行を前後に入れる(MD031)
* コードスパンのマーカー前後に空白を入れない(MD038)
* コードブロックに言語指定を入れる(MD040)
* コードブロックのマーカーに一貫性を持たせる(MD046,MD047)

```markdown
`text`
```

````markdown
```bash
echo "HelloWorld"
```
````

※リスト内にコードブロックを含める場合

````markdown
1. list1
2. list2

    ```bash
    list in codeblock
    ```

3. list3
````

## 引用ブロック

* `>`の後にスペースを入れない(MD027)
* 複数の引用ブロックを空白行だけで区切らない(MD028)

```markdown
>This is a blockquote
>which is immediately followed by
```

## 区切り線

* 記述に一貫性を持たせる(MD035)  

```markdown
---
```

## コメント

通常のHtmlコメント(非推奨)

```html
<!--COMMENT-->
```

レンダーされないコメント

```markdown
[comment]: <> (This is a comment, it will not be included)
```

## MarkdownLint@20210219

* [MD001](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md001) Heading levels should only increment by one level at a time
* [MD002](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md002) First heading should be a top-level heading
* [MD003](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md003) Heading style
* [MD004](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md004) Unordered list style
* [MD005](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md005) Inconsistent indentation for list items at the same level
* [MD006](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md006) Consider starting bulleted lists at the beginning of the line
* [MD007](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md007) Unordered list indentation
* [MD009](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md009) Trailing spaces
* [MD010](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md010) Hard tabs
* [MD011](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md011) Reversed link syntax
* [MD012](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md012) Multiple consecutive blank lines
* [MD013](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md013) Line length
* [MD014](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md014) Dollar signs used before commands without showing output
* [MD018](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md018) No space after hash on atx style heading
* [MD019](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md019) Multiple spaces after hash on atx style heading
* [MD020](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md020) No space inside hashes on closed atx style heading
* [MD021](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md021) Multiple spaces inside hashes on closed atx style heading
* [MD022](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md022) Headings should be surrounded by blank lines
* [MD023](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md023) Headings must start at the beginning of the line
* [MD024](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md024) Multiple headings with the same content
* [MD025](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md025) Multiple top-level headings in the same document
* [MD026](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md026) Trailing punctuation in heading
* [MD027](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md027) Multiple spaces after blockquote symbol
* [MD028](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md028) Blank line inside blockquote
* [MD029](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md029) Ordered list item prefix
* [MD030](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md030) Spaces after list markers
* [MD031](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md031) Fenced code blocks should be surrounded by blank lines
* [MD032](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md032) Lists should be surrounded by blank lines
* [MD033](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md033) Inline HTML
* [MD034](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md034) Bare URL used
* [MD035](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md035) Horizontal rule style
* [MD036](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md036) Emphasis used instead of a heading
* [MD037](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md037) Spaces inside emphasis markers
* [MD038](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md038) Spaces inside code span elements
* [MD039](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md039) Spaces inside link text
* [MD040](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md040) Fenced code blocks should have a language specified
* [MD041](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md041) First line in a file should be a top-level heading
* [MD042](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md042) No empty links
* [MD043](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md043) Required heading structure
* [MD044](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md044) Proper names should have the correct capitalization
* [MD045](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md045) Images should have alternate text (alt text)
* [MD046](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md046) Code block style
* [MD047](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md047) Files should end with a single newline character
* [MD048](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md048) Code fence style
