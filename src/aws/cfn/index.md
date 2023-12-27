# CloudFormation

## CloudFormation Function

```text
Ref -> パラメータ参照
Fn::Base64 -> 文字列をBase64エンコードする
Fn::FindInMap -> Mapから値を取り出す
Fn::GetAtt -> リソースに付随する値を取得する。
    例) "Fn::GetAtt":["MyELB","DNSName"]
Fn::GetAZs -> 指定したリージョンのアベイラビリティゾーンを取得する
Fn::Join -> 文字列を結合する。
    例) "Fn::Join":[":",["a","b"]]は[a:b]を返す
Fn::Select -> Index値に応じた値をListから選択する。
    例){"Fn::Select":["1",["Jan","Feb","Apr"]]}は"Feb"を返す
条件関数 -> Fn::IfやFn::Orなど条件分岐関連Function群
Fn::Sub -> 指定した文字列を置換
Fn::ImportValue -> 別のスタックにてエクスポートされた出力の値を取り出す。通常クロススタック参照した作成に使用
```

## CloudFormation PseudoParameter(疑似パラメータ参照)

```text
AWS::Region -> リージョン名を取得
AWS::StackId -> スタックIDを取得
AWS::StackName -> スタック名を取得
AWS::AccountId -> AWSアカウントIDを取得
AWS::NotificationARNs -> notification Amazon Resource Names(ARNs)を取得
AWS::NoValue -> 指定されたプロパティを無視するようにCloudFormationに伝える
```
