#!/bin/sh

# check jq command is availble
if ! command -v jq &> /dev/null
then
    echo "command not found: jq"

    echo "Please install using:"
    if [[ "$OSTYPE" == "linux-gnu"* ]]
    then
        if command -v yum &> /dev/null; then
            echo "yum install jq"
        elif command -v apt &> /dev/null; then
            echo "apt install jq"
        elif command -v brew &> /dev/null; then
            echo "brew install jq"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]
    then
        echo "brew install jq"
    fi
    exit 1
fi

export jsonfile="./list.json"
# check input json file
if [[ ! -f "$jsonfile" ]]
then
    echo "$jsonfile not found!"
    exit 1
fi

export usage="usage: ./get-value <item-name> <subitem-name>"
# check number of arguments
if (( $# < 2))
then
    echo "$usage"
    exit 1
fi

export itemname=$1
export subitemname=$2

cat $jsonfile | jq '.items[] | select(.name==env.itemname) | .data[] | select(.name==env.subitemname) | .value'