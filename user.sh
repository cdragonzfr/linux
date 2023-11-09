#!/bin/bash

# Script to enumerate users from /etc/passwd on RHEL 8 or CentOS 7
# Output format: Username | UserID | Group | Home Directory | Login Status

while IFS=: read -r user pass uid gid gecos home shell; do
    # Get group name using group ID
    group=$(getent group "$gid" | cut -d: -f1)

    # Check if user has a valid login shell
    if [[ "$shell" != "/sbin/nologin" ]] && [[ "$shell" != "/bin/false" ]]; then
        loginStatus="Can Login"
    else
        loginStatus="Cannot Login"
    fi

    # Print the user information
    echo "$user | $uid | $group | $home | $loginStatus"
done < /etc/passwd
