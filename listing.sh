#!/bin/bash

# Output CSV file
OUTPUT_FILE="output.csv"

# Add CSV header
echo "Filename,Start Date,End Date" > "$OUTPUT_FILE"

# Sample input line (for testing, you can replace this with actual `aws s3 ls` command output processing)
input_line="2023-10-13  04:18:34         14360115  2023-04-12-1243_-_2023-04-13-1242_db_1681410292_1681317955_533_0EB4FD76-8953-49B2-ADF0-A1BBD9CD3C52.tar.gz"

# Process each line
echo "$input_line" | while read -r line; do
  # Extract the filename
  filename=$(echo $line | awk '{print $4}')
  
  # Extract start and end epoch timestamps
  start_epoch=$(echo $filename | grep -oP '\d{10}(?=_\d{10})')
  end_epoch=$(echo $filename | grep -oP '(?<=_\d{10}_)\d{10}')

  # Convert epoch to date and time format (MM/DD/YYYY HH:MM:SS)
  start_date=$(date -d @$start_epoch +'%m/%d/%Y %H:%M:%S')
  end_date=$(date -d @$end_epoch +'%m/%d/%Y %H:%M:%S')

  # Write to CSV
  echo "$filename,$start_date,$end_date" >> "$OUTPUT_FILE"
done

# For actual usage, remove the sample input line and process the output of `aws s3 ls` like so:
# aws s3 ls s3://your-bucket/your-prefix --recursive | while read -r line; do
#   [The rest of the loop goes here]
# done

echo "CSV file created: $OUTPUT_FILE"
