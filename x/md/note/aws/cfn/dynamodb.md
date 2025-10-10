# Dynamodb

動作確認済み@2023/11/01

## cfn-dynamodb.yml

```yml
AWSTemplateFormatVersion: 2010-09-09

Resources:

  ### IAM
  # - ユーザー名:`dynamodb-full`
  # - ロール:AmazonDynamoDBFullAccess
  ### ~/.aws/credentials
  # - プロファイル名:`dynamodb-full`
  ## Command
  ## Get:`aws dynamodb scan --table-name tbl --profile dynamodb-full --region ap-northeast-1`
  ## Put:`aws dynamodb put-item --table-name tbl --item '{ "id": { "N": "1" }, "msg": { "S": "Message" } }' --profile dynamodb-full --region ap-northeast-1`
  ## Del:`aws dynamodb delete-item --table-name tbl --key '{ "id": { "N": "1" }, "msg": { "S": "Message" } }' --profile dynamodb-full --region ap-northeast-1`
  ## 一括削除のためのコマンドはないため、delete-itemでループ処理するかテーブルを作り直す方が早い

  ## ポリシー更新できなくならないよう一部アクション以外をすべて拒否するリソースポリシー
  ## {
  ## 	"Version": "2012-10-17",
  ## 	"Statement": [
  ## 		{
  ## 			"Effect": "Deny",
  ## 			"Principal": "*",
  ## 			"NotAction": [
  ## 				"dynamodb:*ResourcePolicy",
  ## 				"dynamodb:List*",
  ## 				"dynamodb:Describe*"
  ## 			],
  ## 			"Resource": "arn:aws:dynamodb:ap-northeast-1:XXXXXXXXXX:table/XXXXXXXXXXXXX"
  ## 		}
  ## 	]
  ## }

  # DynamoDB
  DynamoDB:
    Type: AWS::DynamoDB::Table
    Properties:
      TableName: tbl
      AttributeDefinitions:
        - AttributeName: id
          AttributeType: N
        - AttributeName: msg
          AttributeType: S
      KeySchema:
        - AttributeName: id
          KeyType: HASH
        - AttributeName: msg
          KeyType: RANGE
      ProvisionedThroughput:
        ReadCapacityUnits: 5
        WriteCapacityUnits: 5
      Tags: 
        - Key: "KEY"
          Value: "VALUE"
```
