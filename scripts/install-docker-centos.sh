#!/bin/bash

set -ex
curuser=`whoami`
if [ "$curuser" != "root" ]; then
    echo "Run this script with root!"
    exit 1
fi

yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

yum install -y yum-utils

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install docker-ce docker-ce-cli containerd.io

service docker start

set +e
which docker-compose > /dev/null 2>&1
if [ $? -ne 0 ]; then
set -e
    echo "Getting and setting up docker-compose"
    curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

docker version
docker-compose --version