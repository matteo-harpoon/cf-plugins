#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:40:39
# @Last modified by:   Matteo
# @Last modified time: 2018-08-21 08:50:53

export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

unset ONLINE_DB
unset MONGO_URL
unset MONGO_DROP_DB_URL
unset NODE_ENV

echo ""
echo "Set NPM Company and Token"
npm config set "$NPM_COMPANY:registry" "https://$NPM_URL/"
npm config set "//$NPM_URL/:_authToken" "$NPM_TOKEN"

echo ""
echo "Install dependencies"
npm install

echo ""
echo "Test Models"
NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/models/mocha.opts"
sleep 5

echo ""
echo "Test DynamicDatas"
NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/dynamic-data/mocha.opts"
sleep 5

echo ""
echo "Test Billings"
NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/billings/mocha.opts"
sleep 5

echo ""
echo "Test Notifications"
NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/notifications/mocha.opts"
sleep 5

echo ""
echo "Test Public API (v1)"
NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/public-v1/mocha.opts"
sleep 5

echo ""
echo "Test UX Flows"
NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/tweak-dashboard-flows/mocha.opts"
sleep 5

echo ""
echo "Test ACLs and Security"
NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/security-acl/mocha.opts"
sleep 5

# TODO: implement this instead
# echo ""
# echo "Run tests and coverage"
# npm run coverage
