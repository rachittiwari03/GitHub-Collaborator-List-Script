#!/bin/bash

#################
# Author: Rachit # Date: Oct 11, 2023
# Version: v1
# This script will report AWS resource usage
#################

# AWS EC2
# AWS S3
# AWS Lambda
# AWS IAM Users



source ~/.bash_profile

set -x
set -e
set -o pipefail

# list S3 buckets
echo "Print the list of S3 buckets"
aws s3 ls > resourceTracker

# list EC2 instance
echo "Print the list of EC2 instances"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> resourceTracker

# list AWS lambda 
echo "Print the lambda functions"
aws lambda list-functions >> resourceTracker


# list IAM Users
echo "Print the IAM Users"
aws iam list-users >> resourceTracker


