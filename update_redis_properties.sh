#!/bin/bash

new_value="$1"
config_file="src/main/resources/cache.properties"
pwd
# Ensure the new value is provided
if [ -z "$new_value" ]; then
    echo "Error: No value provided for redis.address."
    exit 1
fi

sed -i "s|^redis.address=.*|$new_value|" "$config_file"

echo "Updated redis.address in $config_file"