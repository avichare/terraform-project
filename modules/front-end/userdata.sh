#!/bin/bash -v
apt-get update -y
apt-get install awscli
apt-get install leiningen -y


mkdir /workdir
aws s3 cp s3://thoughtworks-jar-files/front-end.jar /workdir/front-end.jar
aws s3 cp s3://thoughtworks-jar-files/static.tgz /workdir/static.tgz
aws s3 cp s3://thoughtworks-jar-files/serve.py /workdir/serve.py
sleep 5
cd /workdir
tar xvzf static.tgz
nohup python3 ./serve.py &
export STATIC_URL="http://localhost:8000"

aws configure set region eu-west-1
token_with_quotes=$(aws ssm get-parameter --name "newsfeed_token" --query Parameter.Value)
token=$(echo "$token_with_quotes" | tr -d '"')
export NEWSFEED_TOKEN=$token
export APP_PORT=8081
java -jar front-end.jar
