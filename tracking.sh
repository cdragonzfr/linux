#!/bin/bash

# Define the path to the master list file
masterListPath="/path/to/masterlist.csv"

# Define the path for the output CSV file
outputCsvPath="/tmp/output.csv"

# Get the current system's hostname
currentHostname=$(hostname)

# Read the master list file and filter the records
# Assuming the CSV file has headers with 'Hostname' and 'DirectoryPath'
filteredRecords=$(awk -F, -v host="$currentHostname" '$1 == host {print $0}' "$masterListPath")

# Initialize the output CSV file and write the headers
echo "Hostname,FilePath,Presence" > "$outputCsvPath"

# Iterate through each filtered record
echo "$filteredRecords" | while IFS=, read -r hostname directoryPath; do
    presence=0

    # Check if the directory path exists
    if [ -d "$directoryPath" ]; then
        presence=1
    fi

    # Write the data to the output CSV file
    echo "$currentHostname,$directoryPath,$presence" >> "$outputCsvPath"
done

# Optional: Display a message when done
echo "Output written to $outputCsvPath"
