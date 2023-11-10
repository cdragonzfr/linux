#!/bin/bash

# Script to list the last logins in the past 30 days excluding 'nobody' accounts
# Output format: Account Name | Session

# Loop through the output of the `last` command
last | while read -r line; do
    # Extract the username and session
    if [[ $line =~ ^([a-zA-Z0-9_\-\.]+)\ +([a-zA-Z0-9\/]+) ]]; then
        user=${BASH_REMATCH[1]}
        session=${BASH_REMATCH[2]}

        # Skip 'nobody' accounts
        if [[ $user != "nobody" ]]; then
            # Print the user and session information
            echo "$user | $session"
        fi
    fi
done
