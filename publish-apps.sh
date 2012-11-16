#!/bin/bash

# Fetch from local credential file
IPLANT_USERNAME=$(cut -f 1 ~/.agave)
TOKEN=$(cut -f 2 ~/.agave)
if [ -z "$TOKEN" ]; then
	echo "No Agave auth token was found. Please run get-token.sh"
	exit 1
fi

LIST=$1

for app in $LIST
do
	echo "PUT $app"
	curl -X PUT -sku "$IPLANT_USERNAME:$TOKEN" "https://foundation.iplantc.org/apps-v1/apps/${app}" > pub.json
	PUB_APPID=$(jshon -e result -e id < pub.json)
	echo -e "Public appid\t${PUB_APPID}"
	rm -rf pub.json
	echo "Done"
done
