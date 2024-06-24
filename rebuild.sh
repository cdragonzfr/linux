#!/bin/bash

# Variables
thawedb_dir="/path/to/thawedb"  # Update this path to your desired directory
splunk_cmd="/path/to/splunk"    # Update this path to your Splunk binary
num_threads=10                  # Number of threads to run in parallel
max_retries=3                   # Maximum number of retries on failure
log_file="/var/log/splunk_process.log"

# Find all files in thawedb_dir and store them in an array
files=($(find "$thawedb_dir" -type f))

# Function to process each file with Splunk command
process_file() {
    local file_path=$1
    local retries=0

    while [ $retries -lt $max_retries ]; do
        if "$splunk_cmd" some_command "$file_path"; then  # Replace 'some_command' with the actual Splunk command
            echo "$(date): Successfully processed $file_path" >> "$log_file"
            return 0
        else
            echo "$(date): Failed to process $file_path. Retrying... ($((retries + 1))/$max_retries)" >> "$log_file"
            retries=$((retries + 1))
        fi
    done

    echo "$(date): Failed to process $file_path after $max_retries attempts" >> "$log_file"
    return 1
}

export -f process_file
export splunk_cmd
export max_retries
export log_file

# Use xargs to run the processing with specified number of parallel threads
echo "$(date): Splunk processing script started" >> "$log_file"
printf "%s\n" "${files[@]}" | xargs -P $num_threads -I {} bash -c 'process_file "$@"' _ {}
echo "$(date): Splunk processing script finished" >> "$log_file"
