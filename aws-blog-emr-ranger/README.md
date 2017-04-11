# Implementing Authorization and Auditing on Amazon EMR Using Apache Ranger
The code in this directory accompanies the AWS Big Data Blog on Implementing Authorization and Auditing on Amazon EMR Using Apache Ranger

## Contents

This subtree contains the following code samples:

- **cloudformation:** Cloudformation scripts to setup the stack
- **scripts:** Scripts used for Installing Ranger and other EMR step actions

aws s3 cp . s3://tes-emr-security/ --recursive --exclude ".DS*" --include "*"