#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:40:39
# @Last modified by:   matteo
# @Last modified time: 2019-04-09 05:00:42

set -e

source $WORKSPACE/cf-plugins/nvm/nvm-bash.sh

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
echo "Set NPM Company and Token"
npm config set "$NPM_COMPANY:registry" "https://$NPM_URL/"
npm config set "//$NPM_URL/:_authToken" "$NPM_TOKEN"

echo ""
echo "Install dependencies"
npm install

echo ""
echo "Run ESLint, TODOs and Test"
npm run test

# TODO: implement this instead
# echo ""
# echo "Run tests and coverage"
# npm run coverage