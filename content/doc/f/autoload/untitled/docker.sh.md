# docker.sh

```bash
#!/bin/bash
dockerexec(){
sudo docker exec -it $1 /bin/bash
}
dockerrminone(){
sudo docker images | awk '/<none/{print $3}' | xargs sudo docker rmi
}
dockerstopall(){
sudo docker stop $(sudo docker ps -a -q)
}
dockerrmall(){
sudo docker rm $(sudo docker ps -a -q)
}
dockerstartonwslforadmin(){
#sudo apt-get install -y docker.io
sudo cgroupfs-mount
#sudo usermod -aG docker $USER
#restart terminal for admin privilege
sudo service docker start
}
dockernginx(){
  sudo docker run --name nginx -d -p 80:80 -p 443:443 -v /var/run/docker.sock:/tmp/docker.sock:ro nginxproxy/nginx-proxy
}
dockerphp(){
  if [ $# -ne 1 ]; then
    echo "require port:$#/1"
  else
    IMAGE=php
    TAG=8.0-apache
    sudo docker run -d --name $IMAGE --hostname $IMAGE -p $1:80 -v "$PWD":/var/www $IMAGE:$TAG
  fi
}
dockercentos7systemd80(){
  sudo docker run -d --name centos7systemd --privileged -p 80:80 -v "$PWD":/var/www centos/systemd
}
```
