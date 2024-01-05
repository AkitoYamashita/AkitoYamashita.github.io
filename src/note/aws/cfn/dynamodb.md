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
