#!/usr/bin bash
set -e

BUCKET_NAME="" # Bucket Name to deploy to
SOLUTION_NAME="" # Application Name
VERSION="" # Version being deployed
ROOT="" # Root of Repository

cd $ROOT/deployment
bash build-s3-dist.sh $BUCKET_NAME $SOLUTION_NAME $VERSION
aws s3 sync regional-s3-assets/ s3://${BUCKET_NAME}/${SOLUTION_NAME}/${VERSION}/
cd global-s3-assets/

# TODO - Megatemplate that defines the other templates in a nested stack. Will also need to sync global-s3-assets for that.

aws cloudformation deploy --template-file 01-sftp-vpc.template --stack-name sftp-vpc-stack --capabilities CAPABILITY_IAM
aws cloudformation deploy --template-file 02-sftp-cognito.template --stack-name sftp-cognito-stack --capabilities CAPABILITY_IAM
