#!/bin/bash

# Get listening ports with process and user information
netstat -anp | grep -i listen | awk '{
    # Extract IP:Port
    split($4, ip_port, ":");
    ipPort = ip_port[1]":"ip_port[2];

    # Extract the process ID and process name
    split($7, pid_proc, "/");
    pid = pid_proc[1];
    processName = pid_proc[2];

    # Get user context for the process
    userContext = (pid == "-" ? "-" : system("ps -o user= -p " pid));

    # Print the formatted output
    print ipPort, processName, userContext;
}'
