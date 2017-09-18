#!/bin/bash
#The script is for ubuntu16.04 to init docker env. Including install docker-ce and docker-compose
#cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse">/etc/apt/sources.list

#DOCKER_VERSION=17.06.0-ce
DOCKER_COMPOSE_VERSION=1.14.0

apt-get update
apt-get install -qy apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get -yq install docker-ce

#install docker-compose. 
#NOTE: sometime, docker-compose installation failed because of network issue, rerun the following two line command.
curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#add aliyun mirror
echo '{
   "registry-mirrors": ["https://pa7zg6wf.mirror.aliyuncs.com"]
}'>/etc/docker/daemon.json
systemctl restart docker

#check if docker and docker-compose installed successfully
if docker version > /dev/null
then
   echo "[INFO] ======docker installed successfully!"
else
   echo "[INFO] ======docker installation failed!"
   exit 1
fi

if docker-compose version > /dev/null
then
   echo "[INFO] ======docker-compose installed successfully!"
else
   echo "[INFO] ======docker-compose installation failed!"
   exit 1
fi