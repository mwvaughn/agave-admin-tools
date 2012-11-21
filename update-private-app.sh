#!/bin/bash

# Fetch from local credential file
IPLANT_USERNAME=$(cut -f 1 ~/.agave)
TOKEN=$(cut -f 2 ~/.agave)
if [ -z "$TOKEN" ]; then
	echo "No Agave auth token was found. Please run get-token.sh"
	exit 1
fi

APPID=$1
JSON_FILE=$2

URL=https://foundation.iplantc.org/apps-v1/apps/$1
set -x
curl -X POST -sku "${IPLANT_USERNAME}:${TOKEN}" -F "fileToUpload=@${JSON_FILE}" ${URL} | python -mjson.tool
set +x
