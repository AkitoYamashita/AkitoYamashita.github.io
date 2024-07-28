# Python

## 簡易WebServer

```python
python -m http.server 8000
##python2.7
#python -m SimpleHTTPServer 8000
```

## リクエストヘッダー出力

```python
import http.server
import socketserver

class MyHttpRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        # Display HTTP request headers
        headers = str(self.headers).replace("\n", "<br>")
        self.wfile.write(bytes(f"<html><body><h1>HTTP Headers</h1><p>{headers}</p></body></html>", "utf8"))

handler_object = MyHttpRequestHandler
PORT = 80
with socketserver.TCPServer(("", PORT), handler_object) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
```

表示サンプル

```
HTTP Headers
X-Forwarded-For: xxx.xxx.xxx.xxx
X-Forwarded-Proto: https
X-Forwarded-Port: 443
X-Amzn-Mtls-Clientcert-Serial-Number: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
X-Amzn-Mtls-Clientcert-Issuer: CN=xxxx.xxx
X-Amzn-Mtls-Clientcert-Subject: CN=xxxx.xxxx.xxx
X-Amzn-Mtls-Clientcert-Validity: NotBefore=2024-07-28T15:02:45Z;NotAfter=2025-08-27T16:02:45Z
X-Amzn-Mtls-Clientcert-Leaf: -----BEGIN%20CERTIFICATE-----%0AXXXCCCCCCCCCCCCCCCCCCCXX%0A-----END%20CERTIFICATE-----%0A
Host: client.bluhh.com
X-Amzn-Trace-Id: Root=1-66a6874b-238c46c22a125acd0e5ee785
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:127.0) Gecko/20100101 Firefox/127.0
accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
accept-language: ja,en-US;q=0.7,en;q=0.3
accept-encoding: gzip, deflate, br, zstd
dnt: 1
sec-gpc: 1
upgrade-insecure-requests: 1
sec-fetch-dest: document
sec-fetch-mode: navigate
sec-fetch-site: none
sec-fetch-user: ?1
priority: u=1
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
