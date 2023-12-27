# EC2Mac

物理MacPCを一切用意せずクラウド環境だけでiOSアプリリリースまでしたときのログ  

## 環境

- 作業元PC: Windows11
- 作業先PC: macOS Venture 13.6.1

## 注意事項

- 2023/12/23 17:00(17:30~) 1h x 約¥200  
- 最終的にEC2を2日半起動して、合計で$86、一日最大$34掛かった
- DedicaedHostsは最低利用時間が24時間
- EC2インスタンスの終了+DedicaedHostsのリリースに40分ほど掛かった

## Ⅰ. OSセットアップ

Reference: <https://qiita.com/kodai_ari/items/c7bfa235768f525bf8cd>

1. 専用ホスト作成  \
    ※Macインスタンスを起動するための専有ホストは一度割り当てを行うと**24時間**はリリースできない
    1. Dedicated Host の設定
        - Tag.Name: `dedicated-host`
        - インスタンスファミリー: `mac1`
        - インスタンスタイプ: `mac1.metal`
        - アベイラビリティーゾーン: `ap-northeast-1a`
        - ホストのメンテナンス.有効化: `false`(無効)
    2. Dedicated Host.作成したインスタンスを選択.インスタンスをホストで起動
        - 名前: `ec2-mac`
        - OS: `macOS`
        - AMI: `macOS Venture 13.6.1`
        - インスタンスタイプ: `mac1.metal`
        - セキュリティグループ作成 \
            (※自動生成での命名になるのでCLIで指定できるならしたほうがいい)
            - Allow SSH traffic from 0.0.0.0/0
            - インターネットからの HTTPS トラフィックを許可: `true`
            - インターネットからの HTTP トラフィックを許可: `true`
        - ストレージ設定:1x`200`GiB, gp3(GeneralPurporseSSD)
        - テナンシー: `専用ホスト`
2. EC2インスタンス起動
3. SSH接続: \
    `chmod 600 ./mac.pem && ssh -i ./mac.pem ec2-user@[xxxx.xxxx.xxxx.xxxx]`
4. バージョン確認: `sw_vers`
5. パスワード更新: `sudo dscl . -passwd /Users/ec2-user [mynewpassword]`
6. VNC有効化:

    ```bash
    sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -clientopts -setvnclegacy -vnclegacy yes -clientopts -setvncpw -vncpw [PASSWORD] -restart -agent -privs -all
    ```

7. AWSセキュリティーグループにVNCポート(TCP:5900)追加
8. VNCクライアントをインストール
    - [RealVNV](https://www.realvnc.com/)
    - [UltraVNC](https://forest.watch.impress.co.jp/library/software/ultravnc/download_11198.html)
9. VNCで[EC2_INSTANCE_IP]:5900で接続
10. Finder設定(隠しファイルの表示)\
    `defaults write com.apple.finder AppleShowAllFiles true && killall Finder`
11. brewのインストール: <https://brew.sh/ja/>

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/usr/local/bin/brew shellenv)"') >> /Users/ec2-user/.zprofile
    ```

12. googlechromeのインストール
13. vscodeのインストール

## Ⅱ. Flutter環境設定

Reference:  

- <https://developer.apple.com/download/all/>
- <https://developer.apple.com/jp/support/xcode/>

1. xcodeインストール
    - iOSシュミレーター
    - iPadシュミレーター
2. fvm/dart導入

    ```bash
    brew tap leoafarias/fvm && brew install fvm
    echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
    ```

3. flutter導入+設定

    ```bash
    fvm install 3.7.7 && fvm global 3.7.7
    echo 'export PATH="$PATH":"$HOME/fvm/default/bin"' >> ~/.zshrc
    ```

4. brew(dart)からfvm(dart)へ切り替え: `brew uninstal dart`
5. Flutterの依存関係のインストール+確認: `flutter doctor`
6. anyenv導入:
    - `git clone https://github.com/anyenv/anyenv ~/.anyenv`

    ```bash
    #vim ~/.zshrc
    if [ -e "$HOME/.anyenv" ]
    then
        export ANYENV_ROOT="$HOME/.anyenv"
        export PATH="$ANYENV_ROOT/bin:$PATH"
        if command -v anyenv 1>/dev/null 2>&1
        then
            eval "$(anyenv init -)"
        fi
    fi
    ```

    - `anyenv install --init`
7. ruby導入

    ```bash
    anyenv install rbenv
    exec $SHELL -l
    rbenv install 3.1.4
    //※3.2.X以降はlibyamlが必要になる
    rbenv global 3.1.4
    source ~/.zshrc && ruby -v
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(rbenv init -)"' >> ~/.zshrc
    ```

8. CocoaPodsのインストール: `gem install cocoapods && pod setup`
9. 初期動作確認: `flutter create [NAME] && cd [NAME] && flutter pub get`

    ```bash
    ##シュミレーター起動
    xcrun simctl boot "iPhone 15 Pro Max" #またはopen -a Simulator
    xcrun simctl boot "iPhone 12 Pro Max" #審査用スクリーンショット6.5インチ
    xcrun simctl boot "iPhone 8 Plus" #審査用スクリーンショット5.5インチ
    flutter devices
    flutter run -d "iPhone 15 Pro Max"`
    ```

## Ⅲ. AppleDeveloper設定1

1. apple developer登録 \
    ※登録処理時間が最大48時間 -> 10分で登録完了メールがきた
2. App ID(Bundle ID)の策定
    Reference: <https://note.com/build_service/n/n227b2420ef5e>
3. Identifierの登録
    - identifier:com.xxxxx
    - capabilities:None \
        ※必要であればDeeplink:associate domains,Push通知:push notification等を付与
4. 開発用デバイスの登録
    Reference: <https://www.micss.biz/2022/06/13/5335/>
    1. AppleDeveloper.Devicesから作成
    2. デバイス登録(Register a New Device)を選択
    3. WindowsにiTunesをインストールし端末をUSB接続の後、端末情報を確認し登録 \
        ※更新した場合はAdHoc用のプロビジョニングプロファイルを再度入れ直す必要あり
5. AppStoreConnect.アプリでプロジェクトを作成
6. AppStoreConnect.ユーザとアクセス.キーでAPIキーを作成し下記を控えておく
    - Issuer ID
    - APIキー
    - p8ファイル

## Ⅳ. AppleDeveloper設定2

```text
証明書署名要求（CSR）=> 公開鍵 + 開発者の情報
証明書(Certificate) => CSR + Appleの署名
Siging Identity(p12) => 公開鍵 + 秘密鍵
Provisioning Profile => AppID + Certificate + DeviceID List
```

### Reference

- iOSアプリをApp Storeに公開する手順:<https://qiita.com/Labi/items/3b71b8f5ef065904c1de>
- FlutterアプリをApp Storeに公開する手順:<https://cat-prog.com/799/>
- iOSアプリ証明書概要:<https://qiita.com/enjapan_common_user/items/7fb6ec3a4dd5fa7e7b82>
- 証明書の有効期限切れまたは無効化:<https://developer.apple.com/jp/support/certificates/#:~:text=%E7%A2%BA%E8%AA%8D%E3%81%8F%E3%81%A0%E3%81%95%E3%81%84%E3%80%82-,%E8%A8%BC%E6%98%8E%E6%9B%B8%E3%81%AE%E6%9C%89%E5%8A%B9%E6%9C%9F%E9%99%90%E5%88%87%E3%82%8C%E3%81%BE%E3%81%9F%E3%81%AF%E7%84%A1%E5%8A%B9%E5%8C%96,-Apple%20Push%20Notification>

1. Xcode でアプリを開く
2. sign&capabilityでAutomaticaly manage signing:trueに設定
3. bundle identifierをapp idで登録したものに変更
4. 証明書CERファイル作成のため、証明書署名要求CSRファイルの準備  
  ※CSRは一般的には対象となるアプリや組織に関する情報を含んでいますが、同じアプリに関連する開発と配布の段階では、その情報が大きく変わることは少ないため、開発用と配布用のCER作成に同じCSRを再利用することが一般的です。
    1. キーチェーンアクセスを起動し、CertificateAssistantの"Request a Certificate From a Certificate Authority.."で認証局へ証明書を要求
        - UserEmailAddress: `[APPLE_DEVELOPER_EMAIL_ADDRESS]`
        - CommonName: `[NAME]` ※キーチェーンアクセスアプリ上ではこのKey名で作成される
        - Request it:`Saved to disk`
        - CA EmailAddress: `(None)`
        - Let me specify key pair information:`true` -> (RSA2048bits)
    2. CertificateSigningRequest.certSigningRequestの保存
5. 証明書CERファイル(Certificate)作成
  Reference: <https://developer.apple.com/jp/help/account/reference/certificate-types/>
    1. 開発用証明書(Apple Development Certificate)development.cerファイルを作成し、ダウンロード  \
        AppleDeveloper.Certificaterから作成
        - Software:`Apple Development`
        - Services:`None`
        - Certificate: `[キーチェーンアクセスで作成したCertificateSigningRequest.certSigningRequest]`
    2. APPSTORE/ADHOC配布用証明書(Apple Distribution Certificate)distribution.cerファイルを作成しダウンロード  \
        AppleDeveloper.Certificaterから作成
        - Software: `Apple Distribution`
        - Services: `None`
        - Certificate: `[キーチェーンアクセスで作成したCertificateSigningRequest.certSigningRequest]`
6. Siging Identity(p12)ファイルの作成\
    (※他PCでも作業が行えるよう各CER作成後に都度行う)
    1. 作成した各証明書CERファイルをダブルクリックし、Macへインストール
    2. p12ファイルで出力
        1. キーチェーンアクセスを起動し、login.Keys(証明書)を選ぶことでCSR作成時の秘密鍵を選択
        2. 展開して、証明書が表示されるので右クリックでExportを行いCertificates.p12ファイルを生成
            - ※パスワードは空でもOK
            - ※同じCSRから作成したCERの場合は一つしか表示されないことがあるが表示されている証明書をp12にした後、削除することで他の証明書が表示される
7. プロビジョニングプロファイルの作成
    1. AppleDeveloper.Profilesから作成
        - Development: `iOS App Development`
        - Distribution: `App Store`
        - App ID: `[Certificatesで作成したAppID]`
        - Provisioning Profile Name: `[NAME_TYPE_PROFILE]`
    2. `[NAME_TYPE_PROFILE].mobileprovision`をダウンロード
8. ipaファイルの作成

    ```bash
    flutter clean
    flutter pub get
    flutter build ipa --release
    ```

9. ストアへアップロード

    ```bash
    #!/bin/bash
    ## APIキー情報
    API_KEY_ID="XXXXXXXXX"
    API_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    API_KEY_PATH="/path/to/AuthKey_XXXXXXX.p8"
    IPA_FILE_PATH="/path/to/flutter/build/ios/ipa/XXXX.ipa"
    ## xcrun altoolコマンドの実行
    xcrun altool --upload-app -f "$IPA_FILE_PATH" -t ios \
    --apiKey "$API_KEY_ID" \
    --apiIssuer "$API_ISSUER_ID" \
    --verbose \
    --file "$API_KEY_PATH"
    ```

10. アプリ申請 \
    ※下記の準備が必要
    - 必須端末用のスクリーンショット
        - iPhone: 6.5インチディスプレイ
        - iPhone: 5.5インチディスプレイ
        - iPadPro(第2世代): 12.9インチディスプレイ
        - iPadPro(第6世代): 12.9インチディスプレイ
    - プライバシーポリシー: URL
    - サポートURL: ※プライバシーポリシーと同じURLでも通った
11. 申請承認
    - 40時間掛かった

## メモ

### for AWS

```json
RunInstances
{
  "MaxCount": 1,
  "MinCount": 1,
  "ImageId": "ami-07dc760123309a8a7",
  "InstanceType": "mac1.metal",
  "KeyName": "mac",
  "EbsOptimized": true,
  "BlockDeviceMappings": [
    {
      "DeviceName": "/dev/sda1",
      "Ebs": {
        "Encrypted": false,
        "DeleteOnTermination": true,
        "Iops": 3000,
        "SnapshotId": "snap-025181a9d028d0be4",
        "VolumeSize": 200,
        "VolumeType": "gp3",
        "Throughput": 175
      }
    }
  ],
  "NetworkInterfaces": [
    {
      "AssociatePublicIpAddress": true,
      "DeviceIndex": 0,
      "Groups": [
        "sg-00c68a263b12ce4c6"
      ]
    }
  ],
  "TagSpecifications": [
    {
      "ResourceType": "instance",
      "Tags": [
        {
          "Key": "Name",
          "Value": "ec2-mac"
        }
      ]
    }
  ],
  "Placement": {
    "HostId": "h-07222ccff52f79f8a",
    "Tenancy": "host"
  },
  "MetadataOptions": {
    "HttpTokens": "required",
    "HttpEndpoint": "enabled",
    "HttpPutResponseHopLimit": 2
  },
  "PrivateDnsNameOptions": {
    "HostnameType": "ip-name",
    "EnableResourceNameDnsARecord": true,
    "EnableResourceNameDnsAAAARecord": false
  }
}
---
CreateSecurityGroup
{
  "GroupName": "launch-wizard-3",
  "Description": "launch-wizard-3 created 2023-12-23T08:13:01.366Z",
  "VpcId": "vpc-d6c17bb2"
}
---
AuthorizeSecurityGroupIngress
{
  "GroupId": "<groupId of the security group created above>",
  "IpPermissions": [
    {
      "IpProtocol": "tcp",
      "FromPort": 22,
      "ToPort": 22,
      "IpRanges": [
        {
          "CidrIp": "0.0.0.0/0"
        }
      ]
    },
    {
      "IpProtocol": "tcp",
      "FromPort": 443,
      "ToPort": 443,
      "IpRanges": [
        {
          "CidrIp": "0.0.0.0/0"
        }
      ]
    },
    {
      "IpProtocol": "tcp",
      "FromPort": 80,
      "ToPort": 80,
      "IpRanges": [
        {
          "CidrIp": "0.0.0.0/0"
        }
      ]
    }
  ]
}
```

### for CLI

1. CLIでの証明書署名要求CSRファイル作成
    - <https://qiita.com/shtnkgm/items/2c9c5eb432c940d66e05>
    - <https://qiita.com/terukazu/items/524b05c03ec1c5616552>

    ```bash
    openssl genrsa -out private.key 2048
    openssl req -new -key private.key -out DevCertificateSigningRequest.certSigningRequest -subj "/emailAddress=[メールアドレス], CN=DevelopmentKey, C=JP"
    ```
  
2. CLIでのp12ファイル作成

    ```bash
    openssl x509 -in ios_development.cer -inform DER -out ios_development.pem -outform PEM
    openssl pkcs12 -export -inkey private.key -in ios_development.pem -out ios_development.p12
    $ Enter Export Password: (None)
    $ Verifying - Enter Export Password: (None)
    ```
