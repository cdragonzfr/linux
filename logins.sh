#!/bin/bash

# Script to list the last logins in the past 30 days
# Output format: Account Name | Session

# Current date in seconds since the epoch
current_date=$(date +%s)

# Loop through the output of the `last` command
last | while read -r line; do
    # Extract the username and session
    if [[ $line =~ ^([a-zA-Z0-9_\-\.]+)\ +([a-zA-Z0-9\/]+) ]]; then
        user=${BASH_REMATCH[1]}
        session=${BASH_REMATCH[2]}

        # Print the user and session information
        echo "$user | $session"
    fi
done
