#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:40:39
# @Last modified by:   Matteo
# @Last modified time: 2018-02-22 01:57:23

export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

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
echo "Store pipeline.json"
(echo "{}" | jq ".git.commit=\"$GIT_COMMIT\"" | jq ".git.url=\"$GIT_URL\"") > $WORKSPACE/pipeline.json
cat $WORKSPACE/pipeline.json

echo ""
echo "Clone Submodules:"
git submodule update --init --recursive

echo ""
echo "Remove package-lock.json for safety"
rm package-lock.json

echo ""
echo "Install dependencies"
npm install

echo ""
echo "Compute locales"
npm run locales-compute
