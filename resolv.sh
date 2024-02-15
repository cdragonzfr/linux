#!/bin/bash

# Define the hostname and two fully qualified domain names (FQDNs)
hostname=$(hostname)
fqdn1="example.com"
fqdn2="example.org"

# Perform nslookup for each hostname/FQDN and extract IP addresses
ip_hostname=$(nslookup "$hostname" | awk '/^Address: / { print $2 }' | tail -n1)
ip_fqdn1=$(nslookup "$fqdn1" | awk '/^Address: / { print $2 }' | tail -n1)
ip_fqdn2=$(nslookup "$fqdn2" | awk '/^Address: / { print $2 }' | tail -n1)

# Output the results in table format
echo -e "Hostname\tIP Address"
echo -e "$hostname\t$ip_hostname"
echo -e "$fqdn1\t$ip_fqdn1"
echo -e "$fqdn2\t$ip_fqdn2"
