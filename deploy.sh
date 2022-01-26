#!/usr/bin bash
set -e

BUCKET_NAME="" # Bucket Name to deploy to
SOLUTION_NAME="" # Application Name
VERSION="" # Version being deployed
ROOT="" # Root of Repository
HOSTEDZONEID="" # Hosted Zone from Route53 : eg mycompanydomain.com
RECORDNAME="" # Record Set Name for domain : eg sftpapi.mycompanydomain.com

cd $ROOT/deployment
bash build-s3-dist.sh $BUCKET_NAME $SOLUTION_NAME $VERSION
aws s3 sync regional-s3-assets/ s3://${BUCKET_NAME}/${SOLUTION_NAME}/${VERSION}/
cd global-s3-assets/ # NOTE: This replaces dist/deployment

aws cloudformation deploy --template-file 01-sftp-vpc.template --stack-name sftp-vpc-stack --capabilities CAPABILITY_IAM
aws cloudformation deploy --template-file 02-sftp-cognito.template --stack-name sftp-cognito-stack --capabilities CAPABILITY_IAM
aws cloudformation deploy --template-file 03-sftp-endpoint.template --stack-name sftp-endpoint-stack --capabilities CAPABILITY_IAM
aws cloudformation deploy --template-file 04-sftp-ecs.template --stack-name sftp-ecs-stack --capabilities CAPABILITY_IAM --parameter-overrides HostedZoneId=$HOSTEDZONEID RecordName=$RECORDNAME
