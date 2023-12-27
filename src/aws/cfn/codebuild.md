# CodeBuild

## cfn-codebuild.md

```yml
AWSTemplateFormatVersion: '2010-09-09'

Resources:

  #CodeBuildのIAMロール
  CodeBuildServiceRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: cfn-codebuild-role
      Policies:
        - PolicyName: cfn-codebuild-policy
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - "*"
                Resource:
                  - "*"
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          Effect: Allow
          Principal:
            Service: codebuild.amazonaws.com
          Action: sts:AssumeRole

  # CodeBuildプロジェクト
  CodeBuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: cfn-codebuild
      ServiceRole: !GetAtt CodeBuildServiceRole.Arn #必須 Ex)arn:aws:iam::442658331843:role/cfn-codebuild-role
      Artifacts: #必須
        Type: no_artifacts
      Environment: #必須
        PrivilegedMode: false
        ComputeType: BUILD_GENERAL1_SMALL
        Image: aws/codebuild/standard:6.0
        Type: LINUX_CONTAINER
        EnvironmentVariables:
          - Name: AWS_DEFAULT_REGION
            Value: !Ref AWS::Region
      Source: #必須
      #   Type: CODECOMMIT
      #   Location: https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/cfn-codecommit #HTTPSクローン
      #   BuildSpec: buildspec.yml
        Type: NO_SOURCE
        BuildSpec: |-
          version: 0.2
          env:
            variable:
              key: "value"
          phases:
            install:
              commands:
                - date
                - echo "デフォルトリージョン:${AWS_DEFAULT_REGION}"
                - echo "ビルドが実行されているリージョン:${AWS_REGION}"
                - echo "ビルドのソースコードのバージョン:${CODEBUILD_RESOLVED_SOURCE_VERSION}"
                - echo "ソースバージョン:${CODEBUILD_SOURCE_VERSION}"
                - echo "現在のビルドをトリガーした Webhook イベント:${CODEBUILD_WEBHOOK_EVENT}"
                - apt-get update
                - apt-get install -y apache2 curl
            pre_build:
              commands:
                - echo 'pre_build'
                - date
                - echo 'start httpd'
                - /etc/init.d/apache2 restart
            build:
              commands:
                - echo 'build'
                - date
                - echo 'curl localhost'
                - curl localhost:80
            post_build:
              commands:
                - echo 'post_build'
                - date
      Tags: 
        - 
          Key: "KEY"
          Value: "VALUE"

```
