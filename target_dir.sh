#!/bin/bash

# Check if input file exists
input_file="input.csv"
if [ ! -f "$input_file" ]; then
    echo "Input file does not exist. Exiting."
    exit 1
fi

# Retrieve the hostname
hostname=$(hostname)

# Output file in /tmp with specific naming convention
output_file="/tmp/${hostname}_bleh_assessment_files_output.csv"

# Add header to the output file
echo "File,Permissions,Owner,Group" > "$output_file"

# Read the CSV and process each directory
tail -n +2 "$input_file" | while IFS=, read -r directory; do
    # Check if the directory exists
    if [ -d "$directory" ]; then
        # Enumerate files and append information to the output file
        find "$directory" -type f -exec stat --format="%n,%A,%U,%G" {} \; >> "$output_file"
    else
        echo "Directory $directory does not exist. Skipping."
    fi
done

echo "Enumeration complete. Results saved to $output_file"



#!/bin/bash

# Check if input file exists
input_file="input.csv"
if [ ! -f "$input_file" ]; then
    echo "Input file does not exist. Exiting."
    exit 1
fi

# Retrieve the hostname
hostname=$(hostname)

# Output file in /tmp with specific naming convention
output_file="/tmp/${hostname}_bleh_assessment_files_output.csv"

# Add header to the output file
echo "File,Permissions,Owner,Group" > "$output_file"

# Read the CSV and process each directory
while IFS=, read -r directory; do
    # Trim whitespace (if necessary)
    directory=$(echo "$directory" | xargs)

    # Debugging output
    echo "Processing directory: '$directory'"

    # Check if the directory exists
    if [ -d "$directory" ]; then
        # Enumerate files and append information to the output file
        find "$directory" -type f -exec stat --format="%n,%A,%U,%G" {} \; >> "$output_file"
    else
        echo "Directory $directory does not exist. Skipping."
    fi
done < <(tail -n +2 "$input_file")

echo "Enumeration complete. Results saved to $output_file"
