#!/bin/bash

# Ensure the script takes exactly two arguments: the input file and the destination directory
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <destination_directory>"
    exit 1
fi

input_file="$1"
destination_directory="$2"
max_jobs=10  # Adjust based on your rate limit
max_retries=3  # Number of retries for each request
retry_delay=5  # Delay between retries in seconds
processed_log="processed_files.log"  # Log file to keep track of processed filenames

copy_object() {
    local key=$1
    local attempt=0

    while [ $attempt -lt $max_retries ]; do
        echo "Attempting to copy: $key (Attempt: $((attempt + 1)))"
        aws s3 cp "s3://$bucket_name/$key" "$destination_directory/$key"
        if [ $? -eq 0 ]; then
            echo "Successfully copied: $key"
            echo "$key" >> "$processed_log"
            return 0
        else
            echo "Failed to copy: $key. Retrying in $retry_delay seconds..."
            sleep $retry_delay
            attempt=$((attempt + 1))
        fi
    done

    echo "Failed to copy: $key after $max_retries attempts."
    return 1
}

export -f copy_object

# Create the processed log file if it doesn't exist
touch "$processed_log"

# Read processed filenames into an array
declare -A processed_files
while IFS= read -r line; do
    processed_files["$line"]=1
done < "$processed_log"

# Process each filename from the input file
cat "$input_file" | while read -r key; do
    # Skip already processed files
    if [[ -n "${processed_files[$key]}" ]]; then
        continue
    fi

    ((i=i%max_jobs)); ((i++==0)) && wait
    copy_object "$key" &
done

wait
echo "All copy requests submitted."
