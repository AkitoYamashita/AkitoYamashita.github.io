# expect.sh

```bash
#!/bin/bash
createsshkeyauto(){
expect -c "
set timeout 10
spawn ssh-keygen -t rsa -C \"\"
expect -re \"Enter file in which to save the key\ (.\*\):\"
send \"\n\"
expect \"Enter passphrase \(empty for no passphrase\):\"
send \"\n\"
expect \"Enter same passphrase again:\"
send \"\n\"
expect eof exit 0
"
}
exp-ssh(){
if [ $# -ne 4 ]; then
  echo "require host/port/user/pass"
else
  HOST=$1
  PORT=$2
  USER=$3
  PASS=$4
  expect -c "
#log_file sshexp.log
set timeout -1
spawn ssh -l $USER $HOST -p $PORT
expect \"Are you sure you want to continue connecting (yes/no)?\" {
    send \"yes\n\"
    expect \"$USER@$HOST's password:\"
    send \"$PASS\n\"
} \"$USER@$HOST's password:\" {
    send \"$PASS\n\"
} \"Permission denied (publickey,gssapi-keyex,gssapi-with-mic).\" {
    exit
}
interact
"
fi
}
exp-sshi(){
if [ $# -ne 5 ]; then
  echo "require host/port/user/pass/identify"
else
  HOST=$1
  PORT=$2
  USER=$3
  PASS=$4
  IDENTIFY=$5
  expect -c "
#log_file sshexp.log
set timeout -1
spawn ssh -l $USER $HOST -p $PORT -i $IDENTIFY
expect \"Are you sure you want to continue connecting (yes/no)?\" {
    send \"yes\n\"
    expect \"$USER@$HOST's password:\"
    send \"$PASS\n\"
} \"$USER@$HOST's password:\" {
    send \"$PASS\n\"
} \"Permission denied (publickey,gssapi-keyex,gssapi-with-mic).\" {
    exit
}
interact
"
fi
}

exp-sudo(){
if [ $# -ne 2 ]; then
  echo "Require [command],[password]"
else
  CMD=$1
  PASS=$2
  expect -c "
    set timeout -1
    spawn sudo $CMD
    expect \"assword\" {
      send \"$PASS\n\"
    }
    interact
  "
fi
}
requireSudo(){
  if [[ "$(id -u)" != "0" ]]; then
    PASS=$(zenity --entry --text="input:")
    CMD=$0
    expect -c "
      set timeout -1
      spawn sudo $CMD
      expect \"assword\" {
        send \"$PASS\n\"
      }
      interact
    "
    exit
  fi
}
```
