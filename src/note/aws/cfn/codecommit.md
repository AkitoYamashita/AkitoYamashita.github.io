# Codecommit

動作確認済み@2023/11/01

## cfn-codecommit.yml

```yml
AWSTemplateFormatVersion: '2010-09-09'

Resources:

  # CodeCommmitレポジトリ
  CodeCommitRepository:
    Type: AWS::CodeCommit::Repository
    Properties:
      RepositoryName: cfn-codecommit
      RepositoryDescription: Test Repository
      Tags: 
        - 
          Key: "KEY"
          Value: "VALUE"
```
