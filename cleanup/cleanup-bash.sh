# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 12:40:49
# @Last modified by:   Matteo
# @Last modified time: 2018-02-21 01:25:11

#!/bin/bash

PKG_VERSION=$(cat package.json | grep '"version": "[a-z0-9\.\-]\{5,\}"' | sed 's/"version": "//g' | sed 's/\ //g' | sed 's/",//g')

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
echo "- URL: $AIRBRAKE_URL"
CLOUDFLARE_BODY="{\"purge_everything\":true}"
echo "- BODY: $AIRBRAKE_BODY"

curl -X DELETE \
  -H "X-Auth-Email: $CLOUDFLARE_USERNAME" \
  -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$CLOUDFLARE_BODY" \
  "$CLOUDFLARE_URL"

echo ""
