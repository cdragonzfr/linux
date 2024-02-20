#!/bin/bash

# Set your bucket and optional prefix here
BUCKET_NAME="your-bucket-name"
PREFIX="your/prefix"

# Set your date range here
START_DATE="2023-01-01"
END_DATE="2023-01-31"

# Initialize total size variable
TOTAL_SIZE=0

# List all files in the S3 bucket and prefix, then filter by date range
aws s3 ls s3://$BUCKET_NAME/$PREFIX --recursive | while read -r line; do
  # Extract the filename from the line
  FILENAME=$(echo $line | awk '{print $4}')
  
  # Assuming the prefix ends before the first date, we use a pattern to extract the date
  # This pattern finds the portion of the filename starting from the first occurrence of a date-like pattern
  FILE_START_DATE=$(echo $FILENAME | grep -oP '\d{4}-\d{2}-\d{2}' | head -n 1)

  # Convert dates to comparable formats
  FILE_DATE=$(date -d "$FILE_START_DATE" +%s)
  COMP_START_DATE=$(date -d "$START_DATE" +%s)
  COMP_END_DATE=$(date -d "$END_DATE" +%s)

  # Check if the file start date falls within the range
  if [ "$FILE_DATE" -ge "$COMP_START_DATE" ] && [ "$FILE_DATE" -le "$COMP_END_DATE" ]; then
    # Extract the file size and sum it up
    FILE_SIZE=$(echo $line | awk '{print $3}')
    TOTAL_SIZE=$((TOTAL_SIZE + FILE_SIZE))
  fi
done

echo "Total size of files in the date range: $TOTAL_SIZE bytes"
