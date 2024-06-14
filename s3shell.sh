#!/bin/bash

BUCKET_NAME="your-bucket-name"
PREFIX="your-prefix/"  # Specify the prefix (folder) you want to query
START_DATE="2023-01-01T00:00:00Z"
END_DATE="2023-12-31T23:59:59Z"
OUTPUT_FILE="glacier-files.txt"

# Initialize the output file
> $OUTPUT_FILE

# Paginate through the list of objects
NEXT_TOKEN=""
while : ; do
  if [[ -z "$NEXT_TOKEN" ]]; then
    RESPONSE=$(aws s3api list-objects-v2 --bucket "$BUCKET_NAME" --prefix "$PREFIX" --query "Contents[?StorageClass=='GLACIER']" --output json)
  else
    RESPONSE=$(aws s3api list-objects-v2 --bucket "$BUCKET_NAME" --prefix "$PREFIX" --query "Contents[?StorageClass=='GLACIER']" --output json --starting-token "$NEXT_TOKEN")
  fi

  # Filter response by date range and append to output file
  echo "$RESPONSE" | jq -r --arg start "$START_DATE" --arg end "$END_DATE" \
  '.[] | select(.LastModified >= $start and .LastModified <= $end) | .Key' >> $OUTPUT_FILE

  # Check for pagination token
  NEXT_TOKEN=$(echo "$RESPONSE" | jq -r '.NextContinuationToken')

  # Break the loop if there is no next token
  if [[ "$NEXT_TOKEN" == "null" ]]; then
    break
  fi
done

echo "List of Glacier files within date range and prefix has been saved to $OUTPUT_FILE"
