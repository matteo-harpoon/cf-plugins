#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:40:39
# @Last modified by:   matteo
# @Last modified time: 2019-03-19 10:40:37

set -e

source $WORKSPACE/cf-plugins/nvm/nvm-bash.sh

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
echo "Unit test"
NODE_ENV=test UNIT_TEST=true ./node_modules/.bin/mocha --opts \"./test/unit/mocha.opts\"
sleep 5

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
NO_STRIPE=false NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/billings/mocha.opts"
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

echo ""
echo "Test DAM"
NODE_ENV=test ./node_modules/.bin/mocha --opts "./test/dam/integration/mocha.opts"
sleep 5

# TODO: implement this instead
# echo ""
# echo "Run tests and coverage"
# npm run coverage
