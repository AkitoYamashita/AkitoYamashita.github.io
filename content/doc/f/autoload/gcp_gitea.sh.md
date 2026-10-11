# gcp_gitea.sh

```bash
#!/usr/bin/env bash
gcp_gitea() {
    ## gcloudコマンドの存在チェック
    if ! command -v gcloud &> /dev/null; then
        echo "gcloud CLI が見つかりません。インストールを開始します。"
        curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts
        ## シェルを再起動してgcloudを使えるようにする
        exec -l $SHELL
    else
        echo "gcloud CLI は既にインストールされています。"
    fi

    ## グローバルIPを取得
    GIP=$(curl -s checkip.amazonaws.com)
    if [ -z "$GIP" ]; then
        echo "グローバルIPの取得に失敗しました。"
        return 1
    fi

    ## ファイアウォールIPを更新
    local new_ip="$1"
    if [ -z "$new_ip" ]; then
        # 引数が指定されなかった場合はGIPを利用
        new_ip="$GIP/32"
    fi

    gcloud config set project [gcp-project-name]
    gcloud compute firewall-rules update [gcp-firewall-rule-name] --source-ranges=xxx.xxx.xxx.xxx/32,"$new_ip"

    if [ $? -eq 0 ]; then
        echo "ファイアウォールルールが更新されました。新しいIP: $new_ip"
    else
        echo "ファイアウォールルールの更新に失敗しました。"
    fi
    
    echo "gcp firewall update complete"
}
```
