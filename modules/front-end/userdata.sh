#!/bin/bash -v
apt-get update -y
apt-get install awscli
apt-get install leiningen -y


mkdir /workdir
aws s3 cp s3://thoughtworks-jar-files/front-end.jar /workdir/front-end.jar
aws s3 cp s3://thoughtworks-jar-files/public /workdir/public

sleep 5
cd /workdir/public
python3 ./serve.py
export STATIC_URL="http://localhost:8000"
cd /workdir
aws ssm get-parameter --name "newsfeed_token" --query Parameter.Value > token.txt
$token=sed s/\"//g token.txt
export NEWSFEED_TOKEN=$token
export APP_PORT=8081
java -jar front-end.jar
