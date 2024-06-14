#!/bin/bash

bucket_name="your-bucket-name"
max_jobs=10  # Adjust based on your rate limit
max_retries=3  # Number of retries for each request
retry_delay=5  # Delay between retries in seconds

restore_object() {
    local key=$1
    local attempt=0

    while [ $attempt -lt $max_retries ]; do
        echo "Attempting to restore: $key (Attempt: $((attempt + 1)))"
        aws s3api restore-object --bucket "$bucket_name" --key "$key" --restore-request '{"Days": 7, "GlacierJobParameters": {"Tier": "Standard"}}'
        if [ $? -eq 0 ]; then
            echo "Successfully restored: $key"
            return 0
        else
            echo "Failed to restore: $key. Retrying in $retry_delay seconds..."
            sleep $retry_delay
            attempt=$((attempt + 1))
        fi
    done

    echo "Failed to restore: $key after $max_retries attempts."
    return 1
}

export -f restore_object

cat filenames.csv | awk -F, 'NR > 1 {print $1}' | while read -r key; do
    ((i=i%max_jobs)); ((i++==0)) && wait
    restore_object "$key" &
done

wait
echo "All restore requests submitted."
