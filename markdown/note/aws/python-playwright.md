# Playwright ブラウザ自動化

## セットアップ

```bash
cd ~/your-project
python3 -m venv .venv
source .venv/bin/activate
pip install playwright
playwright install chromium
```

## ログインセッションの保存

MFAや複雑なログインが絡む場合、手動ログイン後にセッションを保存して使いまわす。

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()

    page.goto("https://example.com")

    input("ログイン完了したらEnterを押す")

    context.storage_state(path="auth.json")
    print("セッション保存完了")
    browser.close()
```

## CSVファイルの順次アップロード（確認待ちあり）

ファイルアップロードを1件ずつ手動確認しながら順番に処理する。

```python
from playwright.sync_api import sync_playwright

CSV_FILES = [
    "/path/to/file_001.csv",
    "/path/to/file_002.csv",
]

URL = "https://example.com/upload"

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    context = browser.new_context(storage_state="auth.json")
    page = context.new_page()

    for i, csv_file in enumerate(CSV_FILES, 1):
        print(f"\n[{i}/{len(CSV_FILES)}] {csv_file}")

        page.goto(URL)
        page.wait_for_load_state("networkidle")

        page.locator("input[type='file']").first.set_input_files(csv_file)
        print("ファイル選択完了")

        page.locator("input[type='submit'][value='アップロード']").click()
        print("アップロード実行")

        page.wait_for_load_state("networkidle")

        input("確認したらEnterで次へ > ")

    print("\n全ファイル完了")
    browser.close()
```

## Tips

- `headless=False` で実際のブラウザを表示して操作できる
- `storage_state` でセッションを保存・再利用できる（MFA対応に有効）
- ボタンが `input[type='submit']` の場合は `get_by_role("button")` では取れない
- ファイル選択inputが複数ある場合は `.first` で絞り込む
- 動的JS描画の画面には `wait_for_load_state("networkidle")` が有効