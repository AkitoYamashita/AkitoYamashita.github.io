# Role and Policy

動作確認済み@2023/11/01

## cfn-role-policy.yml

```yml
AWSTemplateFormatVersion: "2010-09-09"

Resources:

  # IAM Role
  IamRole1:
    Type: AWS::IAM::Role
    Properties:
      RoleName: IamRole1
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - ec2.amazonaws.com
            Action:
              - sts:AssumeRole
      Path: /
      Tags:
        - Key: KEY
          Value: VALUE

  # IAM Policy
  IamPolicy1:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: IamPolicy1
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: "Allow"
            Action:
              - "s3:*"
              - "s3-object-lambda:*"
            Resource: "*"
      Roles:
        - !Ref IamRole1

```
