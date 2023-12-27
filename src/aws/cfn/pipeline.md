# Pipeline

## cfn-pipeline.yml

```yml
AWSTemplateFormatVersion: 2010-09-09

Parameters:
  AppPipeline:
    Type: String
    Default: cfn-pipeline
  SourceRepository: 
    Type: String
    Default: cfn-pipeline-repository
  ArtifactBucket:
    Type: String
    Default: cfn-pipeline-artifact
  DistributionBucket:
    Type: String
    Default: cfn-pipeline-distribution

Resources:

  # CodeCommmit
  PipelineRepository:
    Type: AWS::CodeCommit::Repository
    Properties:
      RepositoryName: !Sub ${SourceRepository}

  # Pipeline EventBridge Polling IAM Role
  EventRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          -
            Effect: Allow
            Principal:
              Service:
                - events.amazonaws.com
            Action: sts:AssumeRole
      Path: /
      Policies:
        -
          PolicyName: eb-pipeline-execution
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              -
                Effect: Allow
                Action: codepipeline:StartPipelineExecution
                Resource: !Join [ '', [ 'arn:aws:codepipeline:', !Ref 'AWS::Region', ':', !Ref 'AWS::AccountId', ':', !Ref AppPipeline ] ]

  # Pipeline EventBridge Polling Event Rule
  EventRule:
    Type: AWS::Events::Rule
    Properties:
      EventPattern:
        source:
          - aws.codecommit
        detail-type:
          - 'CodeCommit Repository State Change'
        resources:
          - !Join [ '', [ 'arn:aws:codecommit:', !Ref 'AWS::Region', ':', !Ref 'AWS::AccountId', ':', !Ref SourceRepository ] ]
        detail:
          event:
            - referenceCreated
            - referenceUpdated
          referenceType:
            - branch
          referenceName:
            # - main
            - master
      Targets:
        -
          Arn: 
            !Join [ '', [ 'arn:aws:codepipeline:', !Ref 'AWS::Region', ':', !Ref 'AWS::AccountId', ':', !Ref AppPipeline ] ]
          RoleArn: !GetAtt EventRole.Arn
          Id: codepipeline-AppPipeline

  # Pipeline IAM Role
  PipelineServiceRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: cfn-pipeline-role
      Policies:
        - PolicyName: cfn-pipeline-policy
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
            Service: codepipeline.amazonaws.com
          Action: sts:AssumeRole

  # Pipeline
  Pipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Name: !Sub ${AppPipeline}
      RoleArn: !GetAtt PipelineServiceRole.Arn
      Stages:
        - Name: Source
          Actions:
            - Name: SourceAction
              ActionTypeId:
                Category: Source
                Owner: AWS
                Version: 1
                Provider: CodeCommit
              OutputArtifacts:
                - Name: SourceArtifact
              Configuration:
                RepositoryName: !Sub ${SourceRepository}
                BranchName: master
                PollForSourceChanges: false ## for EventBridge Polling
              RunOrder: 1
        - Name: Build
          Actions:
            - Name: BuildAction
              InputArtifacts:
                - Name: SourceArtifact
              OutputArtifacts:
                - Name: BuildArtifact
              ActionTypeId:
                Category: Build
                Owner: AWS
                Version: 1
                Provider: CodeBuild
              Configuration:
                ProjectName: !Ref PipelineCodeBuild
              RunOrder: 2
      ArtifactStore:
        Type: S3
        Location: !Sub ${ArtifactBucket}

  # CodeBuild IAM Role
  PipelineCodeBuildServiceRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: cfn-pipeline-codebuild-role
      Policies:
        - PolicyName: cfn-pipeline-codebuild-policy
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

  # CodeBuild Project
  PipelineCodeBuild:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: cfn-pipeline-codebuild
      ServiceRole: !GetAtt PipelineCodeBuildServiceRole.Arn # require
      Artifacts: # require
        Packaging: 'NONE'
        Type: CODEPIPELINE
      Source: # require
        BuildSpec: buildspec.yml
        Type: CODEPIPELINE
      Environment: # require
        PrivilegedMode: false
        ComputeType: BUILD_GENERAL1_SMALL
        #Image: aws/codebuild/amazonlinux2-x86_64-standard:4.0 #AmazonLinux2
        ## Ubuntu 22.04
        Image: aws/codebuild/standard:7.0
        ## https://github.com/aws/aws-codebuild-docker-images/tree/master/ubuntu/standard/7.0
        Type: LINUX_CONTAINER

  # S3 Bucket
  PipelineArtifact:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub ${ArtifactBucket}
      AccessControl: Private
      PublicAccessBlockConfiguration:
        BlockPublicAcls: True
        BlockPublicPolicy: True
        IgnorePublicAcls: True
        RestrictPublicBuckets: True

  # S3 Bucket
  PipelineDistribution:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub ${DistributionBucket}
      PublicAccessBlockConfiguration:
        BlockPublicAcls: False
        BlockPublicPolicy: False
        IgnorePublicAcls: False
        RestrictPublicBuckets: False
      # AccessControl: PublicRead ## Applicable properties after bucket creation
      WebsiteConfiguration:
          ErrorDocument: "404.html"
          IndexDocument: "index.html"
      CorsConfiguration:
        CorsRules:
          - AllowedHeaders:
              - '*'
            AllowedMethods:
              - 'GET'
              - 'PUT'
            AllowedOrigins:
              - '*'

  # S3 Bucket Policy
  PipelineDistributionPolicy:
    Type: "AWS::S3::BucketPolicy"
    Properties:
      Bucket: !Ref PipelineDistribution
      PolicyDocument:
        Version: "2012-10-17"
        Statement: 
          - Action: 
              - "s3:GetObject"
            Effect: "Allow"
            Resource: !Sub "arn:aws:s3:::${DistributionBucket}/*"
            Principal: "*"

Outputs:
  DistributionBucket:
    Value: !Ref PipelineDistribution

```

## buildspec.yml

```yml
version: 0.2

env:
  variable:
    key: "value"

phases:
  install:
    commands:
      - echo install @ `date`
      - pwd
      - echo "デフォルトリージョン:${AWS_DEFAULT_REGION}"
      - echo "ビルドが実行されているリージョン:${AWS_REGION}"
      - echo "ビルドのソースコードのバージョン:${CODEBUILD_RESOLVED_SOURCE_VERSION}"
      - echo "ソースバージョン:${CODEBUILD_SOURCE_VERSION}"
      - echo "現在のビルドをトリガーした Webhook イベント:${CODEBUILD_WEBHOOK_EVENT}"
      - apt-get update
      # - apt-get install -y curl wget make sudo tar bash git unzip
      - apt-get install -y cargo
      - cargo install mdbook
      - /root/.cargo/bin/mdbook build

  pre_build:
    commands:
      - echo pre_build @ `date`

  build:
    commands:
      - echo build @ `date`

  post_build:
    commands:
      - echo post_build @ `date`
      - aws s3 sync --exact-timestamps --delete --exclude 'buildspec.yml' ./book s3://cfn-pipeline-distribution

```
