#!/usr/bin/env bash

S3_PRIMARY_BUCKET_LIST="test-emr-security"

S3_BUCKET_LIST="test-emr-security"


for S3_BUCKET in $S3_BUCKET_LIST; do

    # Copy cloudformations
    pushd cloudformation;

    aws s3 cp . s3://$S3_BUCKET/current/cloudformation/ --content-type 'text/x-yaml' --recursive --profile account1

    popd

    # Copy inputdata
    pushd inputdata;

    aws s3 cp . s3://$S3_BUCKET/current/inputdata/ --content-type 'text/plain' --recursive --acl public-read --profile account1

    popd

     # Copy scripts
    pushd scripts;

    aws s3 cp . s3://$S3_BUCKET/current/scripts/ --content-type 'text/plain' --recursive --acl public-read --profile account1

    popd
done