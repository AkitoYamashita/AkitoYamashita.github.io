# Rocket

## 環境

* rustc 1.52.0-nightly (fe1bf8e05 2021-02-23)

## インストール

* rustはnightlyが必要(20210226時点)

```bash
mkdir -p app
cd app
cargo init
```

`Cargo.toml`の`[dependencies]`に追加

```toml
rocket = "0.4.6"
```


## HelloWorld

* デフォルトポートは8000

```rust
////src/main.rs
#![feature(proc_macro_hygiene, decl_macro)]
#[macro_use] extern crate rocket;
#[get("/")]
fn index() -> &'static str {
    "HelloWorld"
}
fn main() {
    rocket::ignite()
        .mount("/", routes![index])
        .launch();
}
```

```bash
cargo build
cargo run
```

## Step2

md/[name].htmlで[name].mdのマークダウンを変換して表示
トップページはmd/README.mdを表示
サイドバーにMarkdownの一覧表示

* Markdownを表示させる
* ポートを`3000`に変更
* 正規表現のためにregexクレートを追加
* jsonのシリアライズにserdeクレートを追加
* ビューのテンプレートエンジンにHandlebarを利用

`dependencies`を修正

```toml
~~~
[dependencies]
regex = "0.1"
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0.0"
pulldown-cmark = "0.1.2"
rocket = "0.4.6"
rocket_contrib = { version = "0.4", features = ["json","handlebars_templates"] }
handlebars = "3.5"
```

```toml
////Rocket.toml
[global]
address = "0.0.0.0"
port = 3000
template_dir = "templates/"
```

```hbs
{{!--templates/md.hbs--}}
{{#*inline "content"}}
<!--start_#markdown-->
<div id="markdown" class="markdown-body">
{{{text}}}
</div>
<!--end_#markdown-->
{{/inline}}
{{~> layouts/default~}}
```

```hbs
{{!--templates/layouts/default.hbs--}}
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.6,minimum-scale=0.25">
<link rel="stylesheet" href="/style.css?_=0">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto+Sans+JP&display=swap">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/github-markdown-css@3.0.1/github-markdown.min.css">
</head>
<body>
<div id="wrapper">
	<div id="root">
		<main id="main" class="container">
			<article>
				<section>
					{{~> content}}
				</section>
				<aside id="side">
					{{#>side}}
						{{#each items}}
							<a style="display:block;" href="/md/{{lookup ../items @index}}.html">{{lookup ../items @index}}</a>
						{{/each}}
					{{/side}}
				</aside>
			</article>
		</main>
	</div><!--end_#root-->
</div><!--end_#wrapper-->
</body>
</html>
```

```css
/*static/style.css*/
* {
  --bg: rgba(255, 255, 255, 0.7);
  --vp: 10px;
  --hp: 20px;
}

/**/
body {
  margin: 0;
  overflow-y: scroll;
  font-family: "ヒラギノ角ゴ Pro W3", "Hiragino Kaku Gothic Pro", "Yu Gothic Medium", "游ゴシック Medium", YuGothic, "游ゴシック体", "メイリオ", sans-serif;
}

#root {
  display: flex;
  min-height: 100vh;
  flex-direction: column;
}

/**/
a:hover {
  opacity: 0.7;
}

.container {
  margin: 0 auto;
  width: 100%;
  max-width: 960px;
  box-shadow: 0 0 2px 0 rgb(0 0 0 / 25%);
}

/**/
#main {
  flex: 1 0 auto;
  background: var(--bg);
}

#main article {
  box-sizing: border-box;
  display: flex;
  flex-wrap: wrap;
}

article > section {
  order: 1;
  box-sizing: border-box;
  padding: var(--vp) var(--hp) var(--vp) var(--hp);
  width: 640px;
}

article > #side {
  order: 2;
  box-sizing: border-box;
  padding: var(--vp) var(--hp) var(--vp) var(--hp);
  border-left: 1px solid #eaeaea;
  width: 320px;
}

article > #side #side_menu {}

article > #side #side_menu_title {
  font-size: 20px;
  font-weight: bold;
  border-bottom: 1px solid lightgray;
}

article > #side #side_menu ul {
  padding: 15px 0px 15px 30px;
  margin: 0px 0px 0px 0px;
}

article > #side #side_menu ul > li {
  font-size: 14px;
}

article > #side #side_twitter {
  padding: var(--hp) 0px 0px 0px;
}

#markdown {}

@media (max-width: 320px) {
  html {
    width: 320px !important;
    overflow: scroll !important;
  }
}
```

```rust
////src/main.rs
#![feature(proc_macro_hygiene)]
#![feature(decl_macro)]

#[macro_use]

extern crate rocket;

mod markdown;

use rocket_contrib::serve::StaticFiles;
use rocket_contrib::templates::Template;

use markdown::*;

#[catch(404)]
pub fn not_found()->&'static str{"Error:NotFound"}

fn rocket() -> rocket::Rocket {
    rocket::ignite()
      .mount("/", StaticFiles::from("static"))
        .mount("/", routes![index,md])
        .attach(Template::fairing())
        .register(catchers![not_found])
}

fn main() {
    rocket().launch();
}
```

```rust
////src/markdown.rs
extern crate regex;
extern crate pulldown_cmark;

use std::io;
use std::fs;
use std::env;
use std::path::Path;

use regex::Regex;
use serde::Serialize;
use pulldown_cmark::{html,Parser};
use rocket_contrib::templates::Template;

#[derive(Serialize)]
pub struct TemplateContext {
    text: String,
    items: Vec<String>
}

pub fn md_ctx(markdown: String) -> TemplateContext {
    return TemplateContext {
        text: markdown,
        items: md_list()
    };
}

pub fn pwd() -> String {
    return env::current_dir().unwrap().display().to_string();
}

pub fn filename(file: &str) -> &str {
    ////Remove(LastOnly)Extention
    Regex::new(r"(.+?)(\.[^.]*$|$)").unwrap().captures(file).unwrap().at(1).unwrap()
}

pub fn read_dir<P: AsRef<Path>>(path: P) -> io::Result<Vec<String>> {
    Ok(fs::read_dir(path)?
        .filter_map(|entry| {
            let entry = entry.ok()?;
            if entry.file_type().ok()?.is_file() {
                Some(entry.file_name().to_string_lossy().into_owned())
            } else {
                None
            }
        })
        .collect())
}

pub fn md_list() -> Vec<String> {
    let dirs=read_dir(pwd()+"/md").unwrap();
    dirs.iter().map(|i| String::from(filename(&i))).collect::<Vec<String>>()
}

pub fn md_load(path:&str) -> String {
    if Path::new(path).exists() {
        let markdown_str = fs::read_to_string(path).expect("FileReadError");
        let mut html_buf = String::new();
        html::push_html(&mut html_buf,Parser::new(&markdown_str));
        return html_buf;
    }else{
        return String::from("NotFoundMarkdown");
    }
}

pub fn md_render(file: &str) -> Template {
    Template::render("md",md_ctx(md_load(&(pwd()+"/md/"+filename(file)+".md"))))
}

#[get("/md/<name>")]
pub fn md(name: String) -> Template {
    md_render(&name)
}

#[get("/")]
pub fn index() -> Template {
    md_render("README")
}
```

md/配下にマークダウンファイルを配置

```md
# md/README.md

## タイトル

テキスト

```

```bash
cargo run
```

```
cargo build --release
pm2 start target/release/app --name app --watch
```

## Reference

* [Rocket](https://rocket.rs/v0.4/guide/)
