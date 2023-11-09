#!/bin/bash

# Get listening TCP ports with process and user information
netstat -anp | grep -i listen | awk '/^tcp/ || /^tcp6/ {
    # Extract IP:Port
    split($4, ip_port, ":");
    ipPort = ip_port[1]":"ip_port[2];

    # Extract the process ID and process name
    split($7, pid_proc, "/");
    pid = pid_proc[1];
    processName = (pid == "-" ? "-" : pid_proc[2]);

    # Get user context for the process if process ID is available
    if (pid != "-") {
        cmd = "ps -o user= -p " pid;
        cmd | getline userContext;
        close(cmd);
    } else {
        userContext = "-";
    }

    # Print the formatted output
    print userContext, ipPort, processName;
}'
