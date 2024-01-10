# JavaScript

## json-server

1. `npm install json-server --save-dev`
2. `vim db.json`

  db.json

  ```json
  {
    "posts": [
      { "id": 1, "title": "title1", "author": "author1" },
      { "id": 2, "title": "title2", "author": "author2" }
    ],
    "comments": [
      { "id": 1, "body": "body", "postId": 1 }
    ]
  }
  ```

3. `json-server --watch db.json`

## LambdaからBASIC認証付きのHTTPSアクセス

```js
var https = require('https');
exports.handler = function(event, context){
    https.get({
            "host"  : "example.com",
            "port"  : 443,
            "path"  : "/path/to?key=value",
            "auth"  : "username:password"
    }, function(res) {
        res.on("data", function(chunk) {
            context.done(null, chunk);
        });
    }).on('error', function(e) {
        context.done('error', e);
    });
}
```

## LambdaからSNS経由でメール送信

```js
var aws = require('aws-sdk');
var ses = new aws.SES({region: 'us-west-2'});
exports.handler = (event, context, callback) => {
     var params = {
        Destination: {
            ToAddresses: ["test@example.com"]
        },
        Message: {
            Body: {
                Text: { Data: "Test"}
            },
            Subject: { Data: "Test Email"}
        },
        Source: "noreply@example.com"
    };
     ses.sendEmail(params, function (err, data) {
        callback(null, {err: err, data: data});
        if (err) {
            console.log(err);
            context.fail(err);
        } else {
            
            console.log(data);
            context.succeed(event);
        }
    });
};
```

## LambdaからSNS経由でSlack通知

```js
const https = require('https');
const url = require('url');
const slack_url = 'https://hooks.slack.com/services/XXXXXXXXXXX/XXXXXXXXX/xxxxxxxxxxxxxxxxx';
const slack_req_opts = url.parse(slack_url);
slack_req_opts.method = 'POST';
slack_req_opts.headers = {'Content-Type': 'application/json'};

exports.handler = function(event, context) {
  (event.Records || []).forEach(function (rec) {
    if (rec.Sns) {
      var req = https.request(slack_req_opts, function (res) {
        if (res.statusCode === 200) {
          context.succeed('posted to slack');
        } else {
          context.fail('status code: ' + res.statusCode);
        }
      });
      req.on('error', function(e) {
        console.log('problem with request: ' + e.message);
        context.fail(e.message);
      });
      req.write(JSON.stringify({text: JSON.stringify(rec.Sns.Message, null, '  ')}));
      req.end();
    }
  });
};
```

## LambdaからSNS経由でChatwork通知

```js
var https = require('https');
var querystring = require('querystring');

exports.handler = function(event, context) {
  var message = JSON.parse(event.Records[0].Sns.Message);
  var state = (message.NewStateValue == 'ALARM') ? 'error' : 'ok';

  var post_message = "(" + state + ")\n"
   + "[code]\n"
   + message.NewStateValue + "\n"
   + "\n"
   + message.AlarmName + "\n"
   + message.AlarmDescription + "\n"
   + message.NewStateReason + "\n"
   + "[/code]\n";

  var postData = querystring.stringify({
    body: post_message
  });

  var options = {
    host: 'api.chatwork.com',
    port: 443,
    method: 'POST',
    path: '/v2/rooms/XXXXXXXX/messages',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Length': postData.length,
      'X-ChatWorkToken': 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    }
  };

  var req = https.request(options, function (res) {
    res.on('data', function (d) {
      process.stdout.write(d);
    });
    res.on('end', function () {
      context.done();
    });
  });

  req.on('error', function (err) {
    console.log(err);
  });

  req.write(postData);
  req.end();

};
```

## JWT認証サーバ

```js
////Require
const path = require('path');
const fs = require('fs');
const os = require('os');
const ws = require('ws');
const http = require('http');
const cors = require('cors')
const express = require('express');
const passport = require('passport');
const passportHttp = require('passport-http');
const jwt = require("jsonwebtoken");
////JsonWebToken
////https://qiita.com/sa9ra4ma/items/67edf18067eb64a0bf40
const SECRET_KEY = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
app.post('/jwt/', (req, res) => {
  const post_username=req.body.username
  const post_password=req.body.password
  if(post_username==="user"&&post_password==="password"){
    const token = jwt.sign(
      {username:post_username},
      SECRET_KEY,
      {expiresIn:'1days'}
    );
    res.json({ token: token });
  }else{
    res.json({ token: null });
  }
});
const auth = (req, res, next) => {
  let token = '';
  if (req.headers.authorization &&
    req.headers.authorization.split(' ')[0] === 'Bearer') {
    token = req.headers.authorization.split(' ')[1];
  } else {
    return next('token none');
  }
  jwt.verify(token, SECRET_KEY, function (err, decoded) {
    if (err) { // 認証NGの場合
      next(err.message);
    } else { // 認証OKの場合
      req.decoded = decoded;
      next();
    }
  });
}
app.get('/jwt/test', auth, (req, res) => {
  res.send(200, `user is ${req.decoded.user}!`);
});
```
