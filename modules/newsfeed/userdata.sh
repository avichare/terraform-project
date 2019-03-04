#!/bin/bash -v
apt-get update -y
apt-get install awscli
apt-get install leiningen -y


mkdir /workdir
aws s3 cp s3://thoughtworks-jar-files/newsfeed.jar /workdir/newsfeed.jar
sleep 5
cd /workdir
export APP_PORT=8082
java -jar newsfeed.jar
