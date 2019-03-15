#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 03:11:18
# @Last modified by:   matteo
# @Last modified time: 2019-03-15 05:27:11

export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

set -e

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
if [ -z "$BLUEMIX_ENV" ]; then
  echo "Missing environment variable BLUEMIX_ENV"
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
elif [ -z "$NPM_URL" ]; then
  echo "Missing environment variable NPM_URL"
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
echo "Clone Submodules:"

if [ -n "$BITBUCKET_USERNAME" ]; then
  if [ -n "$BITBUCKET_PASSWORD" ]; then
    cat .gitmodules | sed -r s/bitbucket.org/$BITBUCKET_USERNAME:$BITBUCKET_PASSWORD@bitbucket.org/ > .gitmodules.tmp
    rm .gitmodules
    mv .gitmodules.tmp .gitmodules
  fi
fi

if [ -n "$GITLAB_USERNAME" ]; then
  if [ -n "$GITLAB_PASSWORD" ]; then
    cat .gitmodules | sed -r s/gitlab.com/$GITLAB_USERNAME:$GITLAB_PASSWORD@gitlab.com/ > .gitmodules.tmp
    rm .gitmodules
    mv .gitmodules.tmp .gitmodules
  fi
fi

if [ -n "$GITHUB_USERNAME" ]; then
  if [ -n "$GITHUB_PASSWORD" ]; then
    cat .gitmodules | sed -r s/github.com/$GITHUB_USERNAME:$GITHUB_PASSWORD@github.com/ > .gitmodules.tmp
    rm .gitmodules
    mv .gitmodules.tmp .gitmodules
  fi
fi

git submodule update --init --recursive

echo ""
echo "Remove package-lock.json for safety"
rm package-lock.json

echo ""
echo "Set NPM Company and Token"
npm config set "$NPM_COMPANY:registry" "https://$NPM_URL/"
npm config set "//$NPM_URL/:_authToken" "$NPM_TOKEN"

echo ""
echo "Install Serverless Globally"
npm install -g serverless

echo ""
echo "Install dependencies"
npm install

# echo ""
# echo "Test"
# npm run test

for LAMBDA_MODULE in $WORKSPACE/functions/*/
do
  (
    echo ""
    echo "Move to $LAMBDA_MODULE"
    cd "$LAMBDA_MODULE"

    echo ""
    echo "Get to latest commit"
    git fetch origin
    git checkout $GIT_BRANCH
    git pull origin $GIT_BRANCH

    # echo ""
    # echo "Install dependencies"
    # npm install

    # echo ""
    # echo "Test"
    # npm run test
  )
done

echo ""
echo "Move back to WORKSPACE"
cd "$WORKSPACE"

# LAMBDA shouldn't use Tweak API SDK (too big)
# echo ""
# echo "Update SDK"
# npm remove tweak-api
# npm install https://github.com/tweak-com-public/tweak-api-client-javascript-unified.git#$GIT_BRANCH

echo ""
echo "Create local tmp dir"
mkdir $WORKSPACE/tmp

echo ""
echo "Serverless Setup"
NODE_ENV=$BLUEMIX_ENV IS_CI=true npm run serverless-setup

echo ""
echo "Move to ARCHIVE_DIR"
cd $ARCHIVE_DIR

echo ""
echo "Generated files into dist"
ls -a .

echo ""
echo "Deploy"
npm run aws-credentials
npm run serverless-deploy
