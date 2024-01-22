#!/bin/bash

# Define the path for the output CSV file
outputCsvPath="/tmp/output.csv"

# Get the current system's hostname
currentHostname=$(hostname)

# Check if the output CSV file exists
if [ ! -f "$outputCsvPath" ]; then
    # Output CSV does not exist, write out the hostname and message
    echo "${currentHostname}|File does not exist"
    exit
fi

# Read the output CSV file and skip the header line
tail -n +2 "$outputCsvPath" | while IFS=, read -r hostname filePath presence; do
    # Iterate over the data and write it out in Tanium sensor friendly format
    formattedOutput="${hostname}|${filePath}|${presence}"
    echo "$formattedOutput"
done
