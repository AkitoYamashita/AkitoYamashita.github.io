# AWS Operation Tips

- 構成例
  - ルートアカウント(AKT) → **初期設定専用**
    - ルートユーザ保有
    - 請求/支払い管理
    - Organizationの親(管理アカウント)
    - IdC委任元
    - IAM委任元
  - 共通アカウント(COM) → **全体運用専用**
    - IdC委任管理
    - IAMの一元化されたルートアクセス権限持ち
  - Organizationの子アカウント1(XAS) → **ルート認証情報削除後、IdCユーザ運用**
    - 既存アカウントでOrgnization下に招待
  - Organizationの子アカウント2(SOU) → **ルート認証情報削除後、IdCユーザ運用**
    - Orgnization内の子アカウントとして新規作成

## Organizations親/管理アカウント(AKT)でやること（初期セットアップ用）

- MFA を有効化
- root のアクセスキーを作成しない
- 最低限の Budget / コストアラート設定
- IAM Identity Center（SSO）を有効化、委任された管理者(COM)を登録
- IAM メンバーアカウントのための一元化されたルートアクセスに共通アカウント(COM)を登録
- 組織共通の CloudTrail を作成
  - ライフサイクル設定付き S3 バケットへ保存

## (COM)共通アカウントでやること

- SCP/OUの設計・設定
- IdC(SSO) User/Group/PermissionSet設計・設定

## アカウント作成時に共通で行うこと

- IAM ユーザー／ロールによる請求情報へのアクセスを有効化
  - (AccountID) → IDBilling and Cost Management → 請求とコスト管理 → アカウント → IAM ユーザーおよびロールによる請求情報へのアクセス
- ルートMFA設定+アクセスキーを作成しない
  - その後、IAMの一元化されたルートアクセス権限持ち(COM)からルート認証情報の削除
- アカウントエイリアスを設定
- アカウント色設定
