#!/bin/sh

# Check if the required parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <WIN_OS>"
  exit 1
fi

fqdn=$(grep -oE '[a-zA-Z0-9-]+\.delivery\.puppetlabs\.net' "tmp/$1.txt" | head -n 1)

# Check if fqdn is empty
if [ -z "$fqdn" ]; then
  echo "No matching FQDN found in tmp/$1.txt"
  exit 1
fi

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 "Administrator@$fqdn"
