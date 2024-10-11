#!/bin/bash

new_value="$1"
config_file="../src/main/resources/hibernate.properties"

# Ensure the new value is provided
if [ -z "$new_value" ]; then
    echo "Error: No value provided for hibernate.connection.url."
    exit 1
fi

sed -i "s|^hibernate.connection.url=.*|$new_value|" "$config_file"

echo "Updated hibernate.connection.url in $config_file"