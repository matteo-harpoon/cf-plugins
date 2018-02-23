#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:37:21
# @Last modified by:   Matteo
# @Last modified time: 2018-02-22 03:52:56

export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
if [ -z "$BLUEMIX_ENV" ]; then
  echo "Missing environment variable BLUEMIX_ENV"
  exit 1
elif [ -z "$GIT_BRANCH" ]; then
  echo "Missing environment variable GIT_BRANCH"
  exit 1
elif [ -z "$GITHUB_USER_NAME" ]; then
  echo "Missing environment variable GITHUB_USER_NAME"
  exit 1
elif [ -z "$GITHUB_USER_EMAIL" ]; then
  echo "Missing environment variable GITHUB_USER_EMAIL"
  exit 1
elif [ -z "$GITHUB_USERNAME" ]; then
  echo "Missing environment variable GITHUB_USERNAME"
  exit 1
elif [ -z "$GITHUB_PASSWORD" ]; then
  echo "Missing environment variable GITHUB_PASSWORD"
  exit 1
fi

echo "Clone Submodules:"
git submodule update --init --recursive

echo ""
echo "Remove package-lock.json for safety"
rm package-lock.json

echo ""
echo "Install dependencies"
npm install

echo ""
echo "Install JQ"
sudo dpkg -i $WORKSPACE/cf-plugins/jq/jq_1.3-1.1ubuntu1_amd64.deb

echo ""
echo "Get Library Version"
LIB_VERSION=$(cat package.json | jq ".exportedVersion" | sed "s/\"//g")

echo ""
echo "Get Commit Body"
GIT_COMMIT_BODY=$(git log -1 --pretty=format:%B)
echo "$GIT_COMMIT_BODY"

echo ""
echo "Export API Definition"
NODE_ENV="$BLUEMIX_ENV" node codegen.gen.apiDefJSON.js > /dev/null

echo ""
echo "Switch Library to $GIT_BRANCH"
cd "exported/JavaScript/Unified"
git checkout $GIT_BRANCH
cd "$WORKSPACE"

echo ""
echo "Remove Old Library"
mv exported/JavaScript/Unified/.git exported/JavaScript/Unified.git.bk
rm -rf exported/JavaScript/Unified/
mkdir exported/JavaScript/Unified
mv exported/JavaScript/Unified.git.bk exported/JavaScript/Unified/.git

ls exported/JavaScript/Unified

echo ""
echo "Generating Library"
node codegen.genJavaScriptUnified.js > /dev/null
node codegen.genJavaScriptUnifiedAngularModels.js --file $WORKSPACE/exported/tweakApi.json --folder $WORKSPACE/exported/JavaScript/Unified/models.angular/ > /dev/null

echo ""
echo "Configure GIT"
cd exported/JavaScript/Unified
git config user.name "$GITHUB_USER_NAME"
git config user.email "$GITHUB_USER_EMAIL"

echo ""
echo "Update Repository URL"
LIB_GIT_URL=$(git config --get remote.origin.url | sed 's/\/\/github.com/\/\/username:password@github.com/' | sed 's/username/'$GITHUB_USERNAME'/' | sed 's/password/'$GITHUB_PASSWORD'/')
echo "$ git remote add pipeline $LIB_GIT_URL"
git remote add pipeline "$LIB_GIT_URL"

echo ""
echo "Commit code"
git add -A
git commit -m "$GIT_COMMIT_BODY"

echo ""
echo "Push code"
git push pipeline $GIT_BRANCH
