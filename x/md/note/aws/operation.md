# AWS Operation Tips

## ROOT アカウントでやること（初期セットアップ用）

- MFA を有効化
- root のアクセスキーを作成しない
- 最低限の Budget / コストアラートを設定

## Organizations 管理アカウントでやること（通常運用）

- IAM Identity Center（SSO）を有効化
- 組織共通の CloudTrail を作成
  - ライフサイクル設定付き S3 バケットへ保存
- SCP/OU/SSOの設計・設定

## アカウント作成時にやること（新規アカウント共通）

- ルートMFA設定+アクセスキーを作成しない
  - その後、Organizations管理アカウントでルート認証情報の削除
- アカウントエイリアスを設定
- SSO User/Group/PermissionSet作成
- IAM ユーザー／ロールによる請求情報へのアクセスを有効化
  - (AccountID) → IDBilling and Cost Management → 請求とコスト管理 → アカウント → IAM ユーザーおよびロールによる請求情報へのアクセス

## メモ（運用前提）

- 管理アカウントのRootは **初期設定専用**
- Organizationの親アカウントはAWSの全体運用専用
- Organizationの子アカウントはルート認証情報は削除してSSOユーザでの日常運用
