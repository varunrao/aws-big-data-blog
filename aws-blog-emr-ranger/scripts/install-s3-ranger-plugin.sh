#!/bin/bash
set -euo pipefail
set -x
#Variables
export JAVA_HOME=/usr/lib/jvm/java-openjdk
sudo -E bash -c 'echo $JAVA_HOME'
installpath=/usr/lib/ranger
mysql_jar_location=http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar
mysql_jar=mysql-connector-java-5.1.39.jar
s3bucket=$1
ranger_version=$2
ranger_fqdn=$3
if [ "$ranger_version" == "0.7" ]; then
   ranger_s3bucket=$s3bucket/ranger/ranger-0.7.1
   ranger_awss3_plugin=plugin-s3-0.7.1-SNAPSHOT-plugin-awss3
elif [ "$ranger_version" == "0.6" ]; then
   ranger_s3bucket=$s3bucket/ranger/ranger-0.6.1
   ranger_awss3_plugin=plugin-s3-0.7.1-SNAPSHOT-plugin-awss3
else
   ranger_s3bucket=$s3bucket/ranger/ranger-0.5
   ranger_awss3_plugin=plugin-s3-0.7.1-SNAPSHOT-plugin-awss3
fi
#Setup
sudo rm -rf $installpath
sudo mkdir -p $installpath/awss3
sudo chmod -R 777 $installpath
cd $installpath/awss3
wget $mysql_jar_location
aws s3 cp $ranger_s3bucket/$ranger_awss3_plugin.tar.gz . --region us-east-1
aws s3 cp $s3bucket/emrfs/emrfs-hadoop-assembly-2.19.0-SNAPSHOT.jar . --region us-east-1
sudo mkdir -p /usr/share/aws/emr/emrfs/lib/
sudo mkdir -p /usr/share/aws/emr/emrfs/conf/
sudo cp emrfs-hadoop-assembly-2.19.0-SNAPSHOT.jar /usr/share/aws/emr/emrfs/lib/emrfs-hadoop-assembly-2.15.0.jar
tar -xvf $ranger_awss3_plugin.tar.gz
cd $installpath/awss3
sudo cp lib/ranger-awss3-plugin-impl/* /usr/share/aws/emr/emrfs/lib/
sudo sed -i "s|ranger_host|$ranger_fqdn|g" conf/ranger-awss3-audit.xml
sudo sed -i "s|ranger_host|$ranger_fqdn|g" conf/ranger-awss3-security.xml
sudo cp conf/* /usr/share/aws/emr/emrfs/conf/
#sudo cp /usr/lib/hive/httpmime-4.5.2.jar /usr/share/aws/emr/emrfs/lib/
#sudo cp /usr/lib/hive/solr-solrj-5.5.1.jar /usr/share/aws/emr/emrfs/lib/
sudo touch /tmp/awss3app.log
sudo touch /tmp/awss3-ranger_audit.log
sudo chmod 777 /tmp/awss3app.log
sudo chmod 777 /tmp/awss3-ranger_audit.log