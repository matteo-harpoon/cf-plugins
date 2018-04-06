#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 03:11:18
# @Last modified by:   Matteo
# @Last modified time: 2018-02-22 04:16:59

export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
if [ -z "$BLUEMIX_ENV" ]; then
  echo "Missing environment variable BLUEMIX_ENV"
  exit 1
elif [ -z "$ARCHIVE_DIR" ]; then
  echo "Missing environment variable ARCHIVE_DIR"
  exit 1
elif [ -z "$GIT_URL" ]; then
  echo "Missing environment variable GIT_URL"
  exit 1
elif [ -z "$GIT_COMMIT" ]; then
  echo "Missing environment variable GIT_COMMIT"
  exit 1
elif [ -z "$NPM_COMPANY" ]; then
  echo "Missing environment variable NPM_COMPANY"
  exit 1
elif [ -z "$NPM_TOKEN" ]; then
  echo "Missing environment variable NPM_TOKEN"
  exit 1
fi

echo ""
echo "Install JQ"
sudo dpkg -i $WORKSPACE/cf-plugins/jq/jq_1.3-1.1ubuntu1_amd64.deb

echo ""
echo "Store GIT vars on $WORKSPACE/package.json"
(cat package.json | jq ".git.branch=\"$GIT_BRANCH\"" | jq ".git.commit=\"$GIT_COMMIT\"" | jq ".git.url=\"$GIT_URL\"") > $WORKSPACE/package.json.tmp
rm $WORKSPACE/package.json
mv $WORKSPACE/package.json.tmp $WORKSPACE/package.json
cat $WORKSPACE/package.json

echo ""
echo "Remove package-lock.json for safety"
rm package-lock.json

echo ""
echo "Set NPM Company and Token"
npm config set "$NPM_COMPANY:registry" "https://reg.example.com"
npm config set "//reg.example.com/:_authToken" "$NPM_TOKEN"

echo ""
echo "Install dependencies"
npm install

echo ""
echo "Update SDK"
npm remove tweak-api
npm install -D https://github.com/tweak-com-public/tweak-api-client-javascript-unified.git#$GIT_BRANCH

echo ""
echo "Create local tmp dir"
mkdir $WORKSPACE/tmp