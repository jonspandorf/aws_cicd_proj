#!/bin/bash 

# This script is to locally run the panaya home assignment project

cd ./mysql

docker network create mytest_net

echo $PWD
docker build -t panayadb .
docker run --name panayadb --network mytest_net --hostname panayadb --env-file ./.env -d panayadb

cd ..
cd ./webserver
sleep 5
DOCKER_BUILDKIT=0 docker build -t webserver --build-arg MYSQL_HOST="panayadb" --build-arg MYSQL_DB="panaya" --build-arg MYSQL_USER="root" --build-arg MYSQL_PASS="secretpass" --network mytest_net .
docker run --name panayaserver -p 8080:80 webserver 
