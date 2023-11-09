#!/bin/bash

# List all running processes with user context, process ID, and command
ps aux | awk '{print $1, $2, $11}' | tail -n +2
