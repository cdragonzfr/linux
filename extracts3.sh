#!/bin/bash

input_file="liststoinput"
num_threads=10
max_retries=3
destination_dir="/home/tmp"
thawedb_dir="/path/to/thawedb"  # Update this path to your desired extraction directory

# Function to extract the tar file to the specified directory and move it upon success
extract_and_move_tar() {
    local target_path=$1
    local retries=0

    while [ $retries -lt $max_retries ]; do
        if tar -xvf "$target_path" -C "$thawedb_dir" '*/rawdata/journal.zst'; then
            echo "Successfully extracted $target_path to $thawedb_dir"
            mv "$target_path" "$destination_dir"
            echo "Moved $target_path to $destination_dir"
            return 0
        else
            echo "Failed to extract $target_path. Retrying... ($((retries + 1))/$max_retries)"
            retries=$((retries + 1))
        fi
    done

    echo "Failed to extract $target_path after $max_retries attempts"
    return 1
}

export -f extract_and_move_tar
export thawedb_dir
export destination_dir
export max_retries

# Use xargs to run the extraction with 10 parallel processes
cat "$input_file" | xargs -P $num_threads -I {} bash -c 'extract_and_move_tar "$@"' _ {}
