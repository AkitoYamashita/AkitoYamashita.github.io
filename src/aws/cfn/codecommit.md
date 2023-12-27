# Codecommit

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
