#!/bin/bash

# Check if .env file and target file are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 .env_file target_file"
    exit 1
fi

ENV_FILE=$1
TARGET_FILE=$2

# Ensure the .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file $ENV_FILE not found."
    exit 1
fi

# Ensure the target file exists
if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: target file $TARGET_FILE not found."
    exit 1
fi

# Read through the .env file and process each key-value pair
while IFS='=' read -r key value
do
    # Remove trailing spaces from key and value
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)

    # Skip empty lines or comments
    if [ -z "$key" ] || [[ "$key" == \#* ]]; then
        echo "Skipping line: $key"
        continue
    fi
    echo $value
    # Replace only in the respective sections in the target file
    case "$key" in
        nginx_server)
        sed -i "/nginx_server:/!b;n;c\      ansible_host: $value" "$TARGET_FILE"
        ;;
        mongo_server)
        sed -i "/mongo_server:/!b;n;c\      ansible_host: $value" "$TARGET_FILE"
        ;;
        tomcat_server)
        sed -i "/tomcat_server:/!b;n;c\      ansible_host: $value" "$TARGET_FILE"
        ;;
        postgres_server)
        sed -i "/postgres_server:/!b;n;c\      ansible_host: $value" "$TARGET_FILE"
        ;;
        redis_server)
        sed -i "/redis_server:/!b;n;c\      ansible_host: $value" "$TARGET_FILE"
        ;;
        *)
        echo "Unknown key: $key. Skipping."
        ;;
    esac

done < "$ENV_FILE"

echo "Replacement is done."
