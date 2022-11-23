#!/bin/sh

export jsonfile="./list.json"
export itemname=$1
export subitemname=$2
export usage="usage: ./get-value <item-name> <subitem-name>"
export missingfile="input file $jsonfile is missing!"

# check input json file
if [[ ! -f "$jsonfile" ]]
then
    echo "$missingfile"
    exit 1
fi

# check number of arguments
if (( $# < 2))
then
    echo "$usage"
    exit 1
fi

cat $jsonfile | jq '.items[] | select(.name==env.itemname) | .data[] | select(.name==env.subitemname) | .value'