#!/bin/bash

LIST=$1

# Fetch from local credential file
IPLANT_USERNAME=$(cut -f 1 ~/.agave)
TOKEN=$(cut -f 2 ~/.agave)
if [ -z "$TOKEN" ]; then
	echo "No Agave auth token was found. Please run get-token.sh"
	exit 1
fi

for app in $LIST
do
	echo "DELETE $app"
	curl -X DELETE -sku "$IPLANT_USERNAME:$TOKEN" "https://foundation.iplantc.org/apps-v1/apps/${app}" | python -mjson.tool
	echo "Done"
done
