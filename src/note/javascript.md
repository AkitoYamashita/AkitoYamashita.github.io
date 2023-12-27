# JavaScript

### JWT認証サーバ(抜粋)

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
