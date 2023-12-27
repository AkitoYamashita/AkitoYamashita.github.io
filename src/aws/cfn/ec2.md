# EC2(未確認)

```yml
AWSTemplateFormatVersion: "2010-09-09"

Description:
  test-resources

Resources:

  # VPC作成
  TestVPC:                   #リソースの名前【TestVPC】
    Type: AWS::EC2::VPC             #VPC作成するタイプを指定【AWS::EC2::VPC】
    Properties:
      CidrBlock: 10.124.0.0/16      #CidrBlockを指定
      Tags:             #タグの指定、Key、Valueの順に記載する
        - Key: Name
          Value: TEST-VPC

  # インターネットゲートウェイ
  TestIGW:               #リソースの名前【TestIGW】
    Type: AWS::EC2::InternetGateway #インターネットゲートウェイ作成するタイプを指定【AWS::EC2::InternetGateway】
    Properties:
      Tags:             #タグの指定、Key、Valueの順に記載する
        - Key: Name
          Value: TEST-IGW

  # IGWをVPCにアタッチ
  AttachGateway:             #リソースの名前【AttachGateway】
    Type: AWS::EC2::VPCGatewayAttachment    #IGWをVPCにアタッチするタイプを指定【AWS::EC2::VPCGatewayAttachment】
    Properties:
      VpcId: !Ref TestVPC           #【!Ref】は設定済みのリソースを指定できる
      InternetGatewayId: !Ref TestIGW       #今回は上で設定したVPCにIGWを適応する

  # サブネット作成
  TestSubNet1:               #リソースの名前【TestSubNet1】
    Type: AWS::EC2::Subnet      #サブネットを作成するタイプを指定【AWS::EC2::Subnet】
    Properties:
      AvailabilityZone: ap-northeast-1a     #AZの指定
      VpcId: !Ref TestVPC           #【!Ref】で上で設定したVPCを指定
      CidrBlock: 10.124.10.0/24         #CidrBlockを指定
      Tags:                 #タグの指定、Key、Valueの順に記載する
        - Key: Name
          Value: TEST-SubNet1

  # ルートテーブル作成
  TestRouteTable1:           #リソースの名前【TestRouteTable1】
    Type: AWS::EC2::RouteTable      #ルートテーブルを作成するタイプを指定【AWS::EC2::RouteTable】
    Properties:
      VpcId: !Ref TestVPC       #【!Ref】で上で設定したVPCを指定
      Tags:             #タグの指定、Key、Valueの順に記載する
        - Key: Name
          Value: TEST-RouteTable1

  # ルートテーブルの内容を設定
  TestRoute1:                    #リソースの名前【TestRoute1】
    Type: AWS::EC2::Route           #ルートテーブルに設定を登録するタイプを指定【AWS::EC2::Route】
    Properties:
      RouteTableId: !Ref TestRouteTable1        #【!Ref】で適用するルートテーブルを指定
      DestinationCidrBlock: ***.***.***.***/**      #許可するCidrBlockを指定
      GatewayId: !Ref TestIGW               #【!Ref】で適用するIGWを指定

  # ルートテーブルをサブネットに関連付け
  TestSubNetRoutTablAsso:                #リソースの名前【TestSubNetRoutTablAsso】
    Type: AWS::EC2::SubnetRouteTableAssociation     #ルートテーブルをサブネットに関連付けするタイプを指定【AWS::EC2::SubnetRouteTableAssociation】
    Properties:
      SubnetId: !Ref TestSubNet1            #【!Ref】で適用するサブネットを指定
      RouteTableId: !Ref TestRouteTable1        #【!Ref】で適用するルートテーブルを指定

  # セキュリティグループ作成
  TestSecurityGroup:             #リソースの名前【TestSecurityGroup】
    Type: AWS::EC2::SecurityGroup       #セキュリティグループを作成するタイプを指定【AWS::EC2::SecurityGroup】
    Properties:
      GroupName: TEST-SecurityGroup     #ルールのName
      GroupDescription: TEST-SecurityGroup  #ルールの説明
      VpcId:  !Ref TestVPC          #【!Ref】で上で設定したVPCを指定
      SecurityGroupIngress:         #接続許可（複数設定の場合は"-"で区切って連続して書く）
      - 
        IpProtocol: tcp             #プロトコル指定
        CidrIp: ***.***.***.***/**      #送信元IPアドレス
        FromPort: "22"              #送信元ポート
        ToPort: "22"                #送信先ポート

  # EC2（インスタンス作成）
  TestEC2Instance:               #リソースの名前【TestEC2Instance】
    Type: AWS::EC2::Instance            #インスタンスを作成するタイプを指定【AWS::EC2::Instance】
    Properties:
      ImageId: ami-09ebacdc178ae23b7        #AMIのID
      KeyName: TEST-KEY         #キーペア（作成済みのキーペアを指定）
      InstanceType: t2.micro            #インスタンスタイプ
      InstanceInitiatedShutdownBehavior: stop   #シャットダウン動作
      Tenancy: default              #テナンシー
      NetworkInterfaces:            #インターフェースの設定
        - AssociatePublicIpAddress: "true"
          DeviceIndex: "0"          # パブリックIPを自動で割り振り
          SubnetId: !Ref TestSubNet1        #【!Ref】で上で設定したサブネット指定
          GroupSet:
            - !Ref SecGrp           # 上のセキュリティグループを指定
          PrivateIpAddress: 10.124.10.10    # プライベートIPアドレス指定

      Tags:                 #タグの指定、Key、Valueの順に記載する
          - Key: Name
            Value: test_linux_instance
      
      BlockDeviceMappings:          #ストレージの設定
        - DeviceName: /dev/xvda         #デバイス名
          Ebs:
            VolumeType: gp2         #ボリュームタイプ
            DeleteOnTermination: true       #インスタンス終了時に削除するのか
            VolumeSize: 10          #ディスクサイズ（GiB）

      UserData: !Base64 |           #構築後に実行するコマンド
        #!/bin/bash
        sudo hostnamectl set-hostname TEST-LINUX-INSTANCE   #hostname 変更コマンド

  # Elastic IP アドレス作成
  EipTestServer: #リソースの名前【EipFileServer】
    Type: AWS::EC2::EIP #Elastic IP アドレスを作成するタイプを指定【AWS::EC2::EIP】
    Properties:
      InstanceId: !Ref TestEC2Instance #【!Ref】で割り当てるインスタンス指定
```
