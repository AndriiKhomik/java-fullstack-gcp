#!/bin/bash

ENV_FILE=$1
# Ensure the .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file $ENV_FILE not found."
    exit 1
fi

while IFS='=' read -r key value
do
    ssh-keyscan -H $value >> ~/.ssh/known_hosts
done < "$ENV_FILE"

echo "Hosts added"