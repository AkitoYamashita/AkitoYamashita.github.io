# mdBook

## 環境

* rustc 1.52.0-nightly (fe1bf8e05 2021-02-23)

## インストール

```bash
cargo install mdbook
```

## HelloWorld

* `serve`時のデフォルトポートは3000
* `serve`時のライブリロードに利用するWebSocketポートは3001(localhostのみ)

```bash
mkdir -p note
cd note
mdbook init
mdbook build
ls book
```

## step2

* コマンドはMakefileでまとめる
* Markdownディレクトリを`md`ディレクリに変更
* html出力先を`html`ディレクトリに変更
* (細かい挙動を`book.toml`で変更)
* リソースを追加(`theme/additional.css`,`theme/additional.js`)
* highlightjsのカラーテーマを変更
* localhost以外からアクセスさせるためserve時に`-n 0.0.0.0`を指定
* テンプレートを変更したい場合は`theme/index.hbs`や`theme/header.hbs`などを修正

```bash
////シンタックスハイライトをSublimeTextのmonokaiテーマにする
wget https://raw.githubusercontent.com/highlightjs/highlight.js/master/src/styles/monokai-sublime.css -O theme/highlight.css
```

```Makefile
##Makefile
watch:
	mdbook watch
build:
	mdbook build
serve:
	mdbook serve -p 3000 -n 0.0.0.0
```

```toml
##book.toml
[book]
authors = ["root"]
language = "ja"
multilingual = false
src = "md"

[build]
build-dir = "html"
create-missing = false

[output.html]
additional-css = ["theme/additional.css"]
additional-js = ["theme/additional.js"]
mathjax-support = true
no-section-label = true
#google-analytics = "UA-XXXXXXXX"
#site-url = "/note/"

#[preprocessor.random]
#command = "python random.py"
```

```js
////additional.js
(function () {
  var as = document.querySelectorAll('a.header')
  var newList = document.createElement('ul');
  newList.setAttribute('class', 'innerLink');
  for (var i = 1, l = as.length; i < l; i += 1) {
    var a = as[i];
    var label = a.innerText;
    var href = a.getAttribute('href');
    var newAnchor = document.createElement('a');
    newAnchor.setAttribute('href', href);
    newAnchor.innerHTML = label;
    var newItem = document.createElement('li');
    newItem.appendChild(newAnchor);
    newList.appendChild(newItem);
  }
  document.querySelector('.sidebar .active').appendChild(newList);
})();
```

```css
/*theme/additional.css*/

pre > .buttons button {
  color: white;
}

html {
  height: 100%;
}

body {
  min-height: 100%;
  position: relative;
}

.chapter li.chapter-item {
  font-size: 12px;
  line-height: 12px;
}

/**/
ul.innerLink {
  margin: 5px 0px 0px 0px;

}

ul.innerLink > li,
ul.innerLink > li > a {
  font-size: 10px;
  line-height: 12px;
}

ul.innerLink > li > a {
  position: relative;
}

ul.innerLink > li > a:before {
  content: ">>";
  position: absolute;
  left: -1.5em;
}

/**/
.page {
  padding: 57px var(--page-padding) 0px var(--page-padding) !important;
}

.sidebar .sidebar-scrollbox {
  padding: 57px 10px 10px 10px !important;
}
```

## Reference

* [mdBook](https://rust-lang.github.io/mdBook/)
* [rust-lang/mdbook](https://github.com/rust-lang/mdBook)
* [Rust mdbook をちょっと改造してブログにする](https://o296.com/e/mdbook_as_blog.html)
