#!/bin/bash

# Script to list the last logins in the past 30 days
# Output format: Account Name | Session | Process Date | Time

# Current date in seconds since the epoch
current_date=$(date +%s)

# Loop through the output of the `last` command
last | while read -r line; do
    # Extract the username, session, IP address, login date, and time
    if [[ $line =~ ^([a-zA-Z0-9_\-\.]+)\ +([a-zA-Z0-9\/]+)\ +([0-9\.]+)\ +([A-Za-z]{3}\ +[A-Za-z]{3}\ +[0-9]{1,2}\ +[0-9]{2}:[0-9]{2}) ]]; then
        user=${BASH_REMATCH[1]}
        session=${BASH_REMATCH[2]}
        ip_address=${BASH_REMATCH[3]}
        login_date_time=${BASH_REMATCH[4]}

        # Convert login date and time to seconds since the epoch
        login_date_seconds=$(date -d "$login_date_time" +%s)

        # Calculate the difference in days
        difference=$(( (current_date - login_date_seconds) / 86400 ))

        # If the difference is less than or equal to 30 days, print the information
        if [ $difference -le 30 ]; then
            echo "$user | $session | $login_date_time"
        fi
    fi
done
