#!/usr/bin/env bash
aws emr create-cluster --name "KerberizedCluster" \
--release-label emr-5.10.0 \
--instance-type m4.xlarge \
--instance-count 2 \
--ec2-attributes InstanceProfile=EMR_EC2_DefaultRole,KeyName=gcp-css,SubnetId=subnet-c4a0428d \
--service-role EMR_DefaultRole \
--security-configuration MyKerberosConfig \
--applications Name=Hadoop Name=Hive Name=Oozie Name=Spark \
--kerberos-attributes Realm=EC2.INTERNAL,KdcAdminPassword=Password@123,CrossRealmTrustPrincipalPassword=Trust@Password,ADDomainJoinUser=CrossRealmAdmin,ADDomainJoinPassword=Password@123 \
--region us-east-1 \
--bootstrap-actions Path=s3://emr-security/ad/create-hdfs-home-ba.sh,Name=create-hfds-home