#!/bin/bash
set -euo pipefail
set -x
git_repo_path=$1
cd /tmp
sudo yum -y install svn
svn export $git_repo_path aws-blog-emr-ranger