# InstatApps

FlutterでInstantAppsを作ってリリースしたときのログ

Reference:

- <https://medium.com/inspireui/how-to-build-flutter-instant-app-with-fluxstore-7d14c4630ae6>
- <https://wadada420.hatenablog.com/entry/2018/07/25/215159#:~:text=%E3%83%87%E3%82%B8%E3%82%BF%E3%83%AB%E3%82%A2%E3%82%BB%E3%83%83%E3%83%88%E3%83%AA%E3%83%B3%E3%82%AF%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AF%E3%81%99%E3%82%8B%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E8%AD%98%E5%88%A5%E3%81%99%E3%82%8B%E3%80%82>

## 手順

1. 対象アプリ.リリース.設定.詳細設定.フォームファクタ.`Google Play Instant`を有効化
2. アプリ実装
3. `index.html`の`base.href`を無効化 -> `flutter build web`
4. AndroidStdio作業
    1. `SDK Manager`.`Instant Apps Development SDK`をインストール
    2. `android`ディレクトリ右クリック -> `Refactor`.`Enable Instant Apps Support`
    3. `Tools`.`App Links Assistants`
        - Step1:
            - `http://xxxxxx.com` -> `.MainActivity`
            - `https://xxxxxx.com` -> `.MainActivity`
        - Step2:
            1. `.well-known/assetlinks.json`としてファイルを生成し、サイトへ配置 \
                <https://developers.google.com/digital-asset-links/tools/generator?hl=ja>
            ※サイト所有者確認の場合、`android:host="XXX"`は不要?
            2. SearchConsoleでサイト所有者の確認を行う
            3. 対象アプリ.リリース.設定.詳細設定.`アプリのインデックス登録`でHTTP/HTTPSサイトの所有者確認依頼を送る
            4. 対象アプリ.リリース.設定.アプリの完全性.アプリの署名.`Digital Asset Links JSON`をホストに配置 \
                (サイト所有者確認の場合、不要?)
            5. ブラウザからDigital Asset Links APIで確認する
                - HTTP:`https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=http://xxxxxx.com:80&relation=delegate_permission/common.handle_all_urls`
                - HTTPS:`https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://xxxxxx.com:443&relation=delegate_permission/common.handle_all_urls`
    4. `adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://xxxxxx.com:443/"`
5. PlayConsole.製品版.`XXXXXX`から通常アプリをリリース
6. PlayConsole.製品版.`InstantAppsのみ`からリリース
