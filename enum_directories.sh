#!/bin/bash

# Script to enumerate specified directories and their subdirectories
# Output format: Directory Name | Permissions | Owner | Group
# Results are outputted to a file in /tmp with naming convention (hostname)_blah_assessment_output.csv

# Retrieve the hostname
hostname=$(hostname)

# Define the output file with naming convention
output_file="/tmp/${hostname}_blah_assessment_output.csv"

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

# Call the function and redirect output to the file
enumerate_directories "${directories[@]}" > "$output_file"

echo "Enumeration complete. Results saved to $output_file"
