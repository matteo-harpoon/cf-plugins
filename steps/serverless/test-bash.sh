#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:40:39
# @Last modified by:   Matteo
# @Last modified time: 2018-02-21 02:55:29

export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
echo "Set NPM Company and Token"
npm config set "$NPM_COMPANY:registry" "https://$NPM_URL/"
npm config set "//$NPM_URL/:_authToken" "$NPM_TOKEN"

echo ""
echo "Remove package-lock.json for safety"
rm package-lock.json

echo ""
echo "Install dependencies"
npm install

unset NODE_ENV

echo ""
echo "Test Mocha"
npm run test
sleep 5

# TODO: implement this instead
# echo ""
# echo "Run tests and coverage"
# npm run coverage
