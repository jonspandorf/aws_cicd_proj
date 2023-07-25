#!/bin/bash 

# This script is to locally run the panaya home assignment project

cd ./mysql

docker network create mytest_net

echo $PWD
docker build -t panayadb .
docker run --name panayadb --hostname panayadb --env-file ./.env --network mytest_net -d panayadb

cd ..
cd ./webserver
sleep 20
docker build -t webserver --build-arg MYSQL_HOST="panayadb" --build-arg MYSQL_DB="panaya" --build-arg MYSQL_USER="root" --build-arg MYSQL_PASS="secretpass" .
docker run --name panayaserver --network mytest_net -p 8080:80 webserver