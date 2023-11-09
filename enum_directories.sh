#!/bin/bash

# Script to enumerate specified directories and their subdirectories
# Output format: Directory Name | Permissions | Owner | Group

# List of parent directories to target
directories=(/etc /home /opt /root /var)

# Function to enumerate directories
enumerate_directories() {
    for dir in "$@"; do
        # Use find to enumerate directories and subdirectories
        find "$dir" -type d -exec ls -ld {} \; | awk '{
            print $9 "|" $1 "|" $3 "|" $4
        }'
    done
}

# Call the function with the specified directories
enumerate_directories "${directories[@]}"
