#!/bin/bash -v
apt-get update -y
apt-get install awscli
apt-get install leiningen -y


mkdir /workdir
aws s3 cp s3://thoughtworks-jar-files/quotes.jar /workdir/quotes.jar
sleep 5
cd /workdir
export APP_PORT=8083
java -jar quotes.jar
