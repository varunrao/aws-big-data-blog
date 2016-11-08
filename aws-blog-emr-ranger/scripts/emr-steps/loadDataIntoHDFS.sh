#!/bin/bash
set -euo pipefail
set -x
# Define variables
installpath=/tmp
hdfs_data_location=s3://security-poc/inputdata
cd $installpath
sudo aws s3 cp $hdfs_data_location/cars.csv .
sudo aws s3 cp $hdfs_data_location/bank.csv .
sudo -u hdfs hadoop fs -mkdir -p /user/analyst1
sudo -u hdfs hadoop fs -mkdir -p /user/analyst2
sudo -u hdfs hadoop fs -put -f cars.csv /user/analyst1
sudo -u hdfs hadoop fs -put -f bank.csv /user/analyst2
sudo -u hdfs hadoop fs -chown -R analyst1:analyst1 /user/analyst1
sudo -u hdfs hadoop fs -chown -R analyst2:analyst2 /user/analyst2