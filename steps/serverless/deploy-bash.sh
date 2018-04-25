#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 03:11:18
# @Last modified by:   Matteo
# @Last modified time: 2018-04-25 03:38:01

export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
if [ -z "$BLUEMIX_ENV" ]; then
  echo "Missing environment variable BLUEMIX_ENV"
  exit 1
elif [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "Missing environment variable AWS_ACCESS_KEY_ID"
  exit 1
elif [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "Missing environment variable AWS_ACCESS_KEY_ID"
  exit 1
fi

if [ ! -e "$WORKSPACE/node_modules" ]; then
  echo ""
  echo "Install dependencies"
  npm install
fi

echo ""
echo "Serverless Config Credentials"
serverless config credentials --provider aws --key "$AWS_ACCESS_KEY_ID" --secret "$AWS_SECRET_ACCESS_KEY" --profile tweak-serverless --overwrite

echo ""
echo "Deploy"
serverless deploy --package serverless-package
