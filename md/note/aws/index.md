# AWSでよく利用されるサービス上位50選

## EC2 (Elastic Compute Cloud)

- 仮想サーバーを提供するIaaSサービス
- ブラックボックス化しがち
- オンプレ→クラウド化する場合の第一候補
- セキュリティグループのインバウンド・アウトバウンド全開放はやめよう

## S3 (Simple Storage Service)

- オブジェクトストレージ。静的ファイルやバックアップ用途に最適。
- バケットポリシーが便利
- ストレージクラスでコスト最適化が可能
- パブリックアクセスはSCPなど上位の制御でそもそも行えないようにしよう（インシデント率大抵1位）

## RDS (Relational Database Service)

- マネージドなリレーショナルデータベース。
- 常時起動の従量課金(停止しても1週間で自動起動)
- RIなどでコストを抑えることも可能
- メンテナンスやバージョンアップ、バックアップなどオペレーションが発生しがち

## Lambda

- イベント駆動型のサーバーレス実行環境
- ランタイムなどの管理もアプリ側に寄る
- SAMや3rdParty製のサーバレスフレームワークなども併せて採用される場合も多い
- サーバレス構成の場合、よく採用されるが複数のlambdaで処理する構成となることが多いため処理フローがやや複雑化しがち

## VPC (Virtual Private Cloud)

- AWS上の仮想ネットワークを構成
- コスト算出が難しいサービスの一つ
- エンドポイントで意外に費用がかかる

## IAM (Identity and Access Management)

- ユーザーとアクセス権限を管理。
- 呼び方に結構ブレがある、IAM、SSO、IdC、IICなど
- IAMユーザーの払い出しやアクセストークンの利用はしないようにしよう(インシデント率2位)
- 複数アカウントでの運用やSTSなどの一時クレデンシャルの発行、IAMロールでの認証など仕組みは複雑だが有用なものも多い
- アクセス権限管理は終わりのない仕事
- 承認フローで権限付与する仕組みを構築・運用できるとベストか

## CloudWatch

- 監視、メトリクス収集、アラーム設定。
- ロググループに設定するメトリクスフィルターがああ見落としやすい
 -> !sfnの削除でロググループが削除されメトリクスフィルターをトリガーにしていたCWアラームが動かなくなる

## CloudFormation

- インフラ構成のコード化（IaC）。
- いつも現行との差分(ドリフト)やIaCから外れたリソースとの闘い
- CDKと重なる部分もあるが、それぞれメリットがあるので状況、ケースに応じて使い分けれるとベスト

## ECS (Elastic Container Service)

- Dockerコンテナの実行・管理。

## EKS (Elastic Kubernetes Service)

- Kubernetesのマネージドサービス。

## DynamoDB

- スケーラブルなNoSQLデータベース。

## Route 53

- DNSサービス。ドメイン管理と名前解決。

## CloudFront

- グローバルCDNサービス。

## SNS (Simple Notification Service)

- Pub/Sub型の通知サービス。

## SQS (Simple Queue Service)

- 分散アプリ間の非同期通信。

## Elastic Beanstalk

- アプリケーションデプロイのPaaS。

## ElastiCache

- RedisやMemcachedによるインメモリキャッシュ。

## ELB(ALB,NLB)

- ロードバランサー(負荷分散する仕組み)。
ALBはL7、NLBはL4。

## CodePipeline

- CI/CDパイプラインの構築。

## CodeBuild

- ビルド自動化サービス。

## CodeDeploy

- デプロイメント自動化。

## Systems Manager (SSM)

- インスタンス管理と自動化操作。

## KMS (Key Management Service)

- 暗号鍵の管理サービス。

## Secrets Manager

- 認証情報の安全な保管・取得。

## Step Functions

- ワークフローの状態管理サービス。

## Glue

- ETL処理のためのサーバーレスデータ統合サービス。

## Athena

- S3上のデータを直接SQLでクエリ。

## Redshift

- データウェアハウス（DWH）サービス。

## Cognito

- ユーザー認証と認可を簡単に実装。

## CloudTrail

- AWS APIコールの監査ログ記録。

## EFS (Elastic File System)

- 複数インスタンス間で共有可能なファイルシステム。

## EventBridge

- サーバーレスイベントバス。マイクロサービス連携に活用。

## QuickSight

- BIツール。データ可視化とダッシュボード作成。

## Config

- リソース構成変更の記録と監査。

## Backup

- マネージドバックアップサービス。スナップショットや復元対応。

## Organizations

- 複数AWSアカウントの統合管理。

## SSM パラメータストア

- 設定情報・シークレットの安全な保管。

## Cost Explorer

- コスト分析と可視化。

## Inspector

- 脆弱性診断サービス。

## WAF (Web Application Firewall)

- Webアプリへの攻撃を防ぐ。

## API Gateway

- REST / WebSocket API のフロントエンド。

## Amplify

- モバイル/Webアプリのホスティングと認証統合。

## SageMaker

- 機械学習の構築・学習・推論を統合的に提供。