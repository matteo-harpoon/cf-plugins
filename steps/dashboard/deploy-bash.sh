#!/bin/bash

# @Author: Matteo Zambon <Matteo>
# @Date:   2018-02-21 02:40:39
# @Last modified by:   Matteo
# @Last modified time: 2018-02-21 03:13:32

echo ""
echo "Move to WORKSPACE"
cd "$WORKSPACE"

echo ""
if [ -z "$BLUEMIX_ENV" ]; then
  echo "Missing environment variable BLUEMIX_ENV"
  exit 1
elif [ -z "$CF_APP" ]; then
  echo "Missing environment variable CF_APP"
  exit 1
fi

echo ""
echo "Install CF plugins"
cf install-plugin -f 'cf-plugins/autopilot/autopilot-linux'
cf install-plugin -f 'cf-plugins/antifreeze/antifreeze-linux'

echo ""
echo "Remove unused path CF plugins"
rm -rf cf-plugins

echo ""
echo "Set Manifest"
BLUEMIX_MANIFEST="server/bluemix/manifest.$BLUEMIX_ENV.yaml"
echo "$BLUEMIX_MANIFEST"

echo ""
echo "Check Manifest (antifreeze)"
cf check-manifest "${CF_APP}" -f "$BLUEMIX_MANIFEST"

echo ""
echo "Deploy (zero-downtime-push"
cf zero-downtime-push "${CF_APP}" -f "$BLUEMIX_MANIFEST" -p .
