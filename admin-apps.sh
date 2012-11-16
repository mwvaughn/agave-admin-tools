#!/bin/bash

# Fetch from local credential file
IPLANT_USERNAME=$(cut -f 1 ~/.agave)
TOKEN=$(cut -f 2 ~/.agave)
if [ -z "$TOKEN" ]; then
	echo "No Agave auth token was found. Please run get-token.sh"
	exit 1
fi

FNAME="temp.${PPID}.json"
curl -X GET -sku "$IPLANT_USERNAME:$TOKEN" https://foundation.iplantc.org/apps-v1/apps/list > $FNAME

# Count apps avail to share/list
COUNT=$(jshon -e result -l < $FNAME)
echo "${COUNT} entries in /apps/list"

# Iterate through app catalog
for APP in $(seq 0 $COUNT)
do
APPID=$(jshon -e result -e $APP -e id < $FNAME)
APPID=$(echo $APPID | tr -d '"')
#echo -e "${APP}\t${APPID}"
apps[$APP]=$APPID
done

# Sort
apps_sorted=($(printf '%s\n' "${apps[@]}"|sort -r -d))

# Iterate, offering option to publish
for var in "${apps_sorted[@]}"
do

	if [[ $var =~ u[0123456789] ]];
	then
		echo -e "Public: ${var}"
		echo " "
	else
		echo -e "Private: ${var}"
		echo -n "  Do you wish to publish $var ? (y/N)"
		read answer
		if [ "$answer" == "y" ];
		then
			curl -X PUT -sku "$IPLANT_USERNAME:$TOKEN" "https://foundation.iplantcollaborative.org/apps-v1/apps/${var}" > pub.json
			PUB_APPID=$(jshon -e result -e id < pub.json)
			echo "Public appid is ${PUB_APPID}"
			rm -rf pub.json
			echo " "
		fi
	fi

done

rm -rf $FNAME