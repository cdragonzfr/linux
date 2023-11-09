#!/bin/bash

# Enumerate /home directory for user profile directories
# Output: Directory Name | Permissions | Owner
ls -l /home | grep '^d' | awk '{
    print $9 "|" $1 "|" $3
}'
