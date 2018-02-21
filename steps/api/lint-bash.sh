#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:40:39
# @Last modified by:   Matteo
# @Last modified time: 2018-02-21 02:54:34

export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
echo "Install dependencies"
npm install

echo ""
echo "Run ESLint"
npm run eslint

echo ""
echo "Show TODOs"
npm run todo

# TODO: implement this instead
# echo ""
# echo "Run tests and coverage"
# npm run coverage