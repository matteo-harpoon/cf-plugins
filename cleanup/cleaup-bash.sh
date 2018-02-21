#!/bin/bash

echo ""
echo "Let Airbrake know we've deployed a new version"
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"environment":"'${BLUEMIX_ENV}'","username":"'${AIRBRAKE_USERNAME}'","repository":"'${GIT_URL}'","revision":"'${GIT_COMMIT}'"}' \
  "https://airbrake.io/api/v4/projects/${AIRBRAKE_PROJECT_ID}/deploys?key=${AIRBRAKE_PROJECT_KEY}"

echo ""
echo "Purge Cloudflare cache"
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/purge_cache" \
     -H "X-Auth-Email: $CLOUDFLARE_USERNAME" \
     -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'

