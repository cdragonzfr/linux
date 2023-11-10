#!/bin/bash

# Script to list the last logins in the past 30 days
# Output format: Account Name | Process Date | Time

# Current date in seconds since the epoch
current_date=$(date +%s)

# Loop through the output of the `last` command
last | while read -r line; do
    # Extract the username, login date, and time
    if [[ $line =~ ^([a-zA-Z0-9_\-\.]+)\ +pts\/[0-9]+ ]]; then
        user=${BASH_REMATCH[1]}
        login_date=$(echo $line | awk '{print $4, $5, $6}')
        login_time=$(echo $line | awk '{print $7}')

        # Convert login date to seconds since the epoch
        login_date_seconds=$(date -d "$login_date" +%s)

        # Calculate the difference in days
        difference=$(( (current_date - login_date_seconds) / 86400 ))

        # If the difference is less than or equal to 30 days, print the information
        if [ $difference -le 30 ]; then
            echo "$user | $login_date | $login_time"
        fi
    fi
done
