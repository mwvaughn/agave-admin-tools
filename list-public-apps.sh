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

# Iterate through app catalog
for APP in $(seq 0 $COUNT)
do
	APPID=$(jshon -e result -e $APP -e id < $FNAME)
	APPID=$(echo $APPID | tr -d '"')
	
	DESC=$(jshon -e result -e $APP -e shortDescription < $FNAME)
	DESC=$(echo "${DESC}" | tr -d '"')	
	apps[$APP]="$APPID\t$DESC"
done

# Sort
#apps_sorted=($(printf '%s\n' "${apps[@]}"|sort -r -d -k1,1+))

# Iterate, offering option to publish
for var in "${apps[@]}"
do
if [[ $var =~ u[0123456789] ]];
then
	echo -e "Public\t${var}" >> tempapps.$$.txt
fi
done

sort -k2,2 tempapps.$$.txt

rm tempapps.$$.txt
