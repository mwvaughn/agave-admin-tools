#!/bin/bash

echo -n "iPlant username: "
read IPLANT_USERNAME

echo "Getting authentication token"

TOKEN=$(curl -X POST -sku "$IPLANT_USERNAME" -d "lifetime=172800" https://foundation.iplantc.org/auth-v1/ | jshon -e result -e token | tr -d '"')

echo "Token: $TOKEN"
echo -e "$IPLANT_USERNAME\t$TOKEN" > ~/.agave
