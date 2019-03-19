#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:40:39
# @Last modified by:   matteo
# @Last modified time: 2019-03-19 10:44:07

set -e

source $WORKSPACE/cf-plugins/nvm/nvm-bash.sh

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
if [ -z "$GIT_URL" ]; then
  echo "Missing environment variable GIT_URL"
  exit 1
elif [ -z "$GIT_COMMIT" ]; then
  echo "Missing environment variable GIT_COMMIT"
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
git submodule update --init --recursive

echo ""
echo "Update Submodules:"
cd $WORKSPACE/assets/tweak-button
git pull origin master
cd $WORKSPACE

echo ""
echo "Remove package-lock.json for safety"
rm package-lock.json

echo ""
echo "Set NPM Company and Token"
npm config set "$NPM_COMPANY:registry" "https://$NPM_URL/"
npm config set "//$NPM_URL/:_authToken" "$NPM_TOKEN"

echo ""
echo "Install dependencies"
npm install

echo ""
echo "Compute locales"
npm run locales-compute

echo ""
echo "Store NPM Company and Token"
printf "//$NPM_URL/:_authToken=$NPM_TOKEN\n$NPM_COMPANY:registry=https://$NPM_URL/" > "$WORKSPACE/.npmrc"

echo ""
echo "Create local tmp dir"
mkdir $WORKSPACE/tmp
