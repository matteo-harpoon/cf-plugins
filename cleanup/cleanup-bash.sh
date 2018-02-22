#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 12:40:49
# @Last modified by:   Matteo
# @Last modified time: 2018-02-22 12:29:54

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
if [ -z "$BLUEMIX_ENV" ]; then
  echo "Missing environment variable BLUEMIX_ENV"
  exit 1
elif [ -z "$AIRBRAKE_PROJECT_ID" ]; then
  echo "Missing environment variable AIRBRAKE_PROJECT_ID"
  exit 1
elif [ -z "$AIRBRAKE_PROJECT_KEY" ]; then
  echo "Missing environment variable AIRBRAKE_PROJECT_KEY"
  exit 1
elif [ -z "$AIRBRAKE_USERNAME" ]; then
  echo "Missing environment variable AIRBRAKE_USERNAME"
  exit 1
elif [ -z "$CLOUDFLARE_ZONE_ID" ]; then
  echo "Missing environment variable CLOUDFLARE_ZONE_ID"
  exit 1
elif [ -z "$CLOUDFLARE_USERNAME" ]; then
  echo "Missing environment variable CLOUDFLARE_USERNAME"
  exit 1
elif [ -z "$CLOUDFLARE_API_KEY" ]; then
  echo "Missing environment variable CLOUDFLARE_API_KEY"
  exit 1
fi

echo ""
echo "Install JQ"
sudo apt-get update
sudo apt-get install -y jq

echo ""
echo "Get Library Version"
PKG_VERSION=$(cat $WORKSPACE/package.json | jq ".version" | sed "s/\"//g")
echo "$PKG_VERSION"

echo ""
echo "Get GIT Commit"
GIT_COMMIT=$(cat $WORKSPACE/pipeline.json | jq ".git.commit" | sed "s/\"//g")
echo "$GIT_COMMIT"

echo ""
echo "Get GIT URL"
GIT_URL=$(cat $WORKSPACE/pipeline.json | jq ".git.url" | sed "s/\"//g")
echo "$GIT_URL"

echo ""
if [ -z "$PKG_VERSION" ]; then
  echo "Missing environment variable PKG_VERSION"
  exit 1
elif [ -z "$GIT_COMMIT" ]; then
  echo "Missing environment variable GIT_COMMIT"
  exit 1
elif [ -z "$GIT_URL" ]; then
  echo "Missing environment variable GIT_URL"
  exit 1
fi

echo ""
echo "Let Airbrake know we've deployed a new version"
AIRBRAKE_URL="https://airbrake.io/api/v4/projects/$AIRBRAKE_PROJECT_ID/deploys?key=$AIRBRAKE_PROJECT_KEY"
echo "- URL: $AIRBRAKE_URL"
AIRBRAKE_BODY="{\"environment\":\"$BLUEMIX_ENV\",\"username\":\"$AIRBRAKE_USERNAME\",\"repository\":\"$GIT_URL\",\"revision\":\"$GIT_COMMIT\",\"version\":\"v$PKG_VERSION\"}"
echo "- BODY: $AIRBRAKE_BODY"

curl -X POST \
  -H "Content-Type: application/json" \
  -d "$AIRBRAKE_BODY" \
  "$AIRBRAKE_URL"

echo ""

echo ""
echo "Purge Cloudflare cache"
CLOUDFLARE_URL="https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/purge_cache"
echo "- URL: $CLOUDFLARE_URL"
CLOUDFLARE_BODY="{\"purge_everything\":true}"
echo "- BODY: $CLOUDFLARE_BODY"

curl -X DELETE \
  -H "X-Auth-Email: $CLOUDFLARE_USERNAME" \
  -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$CLOUDFLARE_BODY" \
  "$CLOUDFLARE_URL"

echo ""
