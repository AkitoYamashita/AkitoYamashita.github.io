# Python

## Pythonで簡易WebServer
```python
python -m http.server 8000
//python2.7
//python -m SimpleHTTPServer 8000
```

## LamndaでAWS Systems Managerのパラメータストア更新

```python
import boto3

ssm = boto3.client('ssm')

def get_param(key: str) -> str:
    global ssm
    try:
        return ssm.get_parameter(Name=key)['Parameter']['Value']
    except ssm.exceptions.ParameterNotFound:
        return None

def set_param(key: str, value: str):
    global ssm
    ssm.put_parameter(Name=key, Value=value, Type='String', Overwrite=True)

def lambda_handler(event, context):
    key = 'counter'
    count = int(get_param(key) or 0)
    count += 1
    set_param(key, str(count))
    return count
```

## Lamndaでの日付出力(YYYYMMDD)

```python
import json
import datetime
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': datetime.datetime.now(
            datetime.timezone(
                datetime.timedelta(hours=9)
            )
        ).strftime(
            '%Y%m%d'
        )
    }
```

## Lamndaでの日時出力(YYYYMMDDHHMMSSSSS)

```python
import json
import datetime
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': datetime.datetime.now(
            datetime.timezone(
                datetime.timedelta(hours=9)
            )
        ).strftime(
            '%Y%m%d%H%M%S%f'
        )[:-3]
    }
```

## LambdaでSNS経由のメール送信

```python
import boto3

def lambda_handler(event, context):
    sns_client = boto3.client('sns')
    sns_client.publish(
        TopicArn='arn:aws:sns:ap-northeast-1:000000000000:xxxxxxxx',
        Subject='タイトル',
        Message='メッセージ',
    )
    return "ok"
```
