#!/bin/sh
#
# Available images at the time of writing on vmpooler
#
# win-10-ent-i386
# win-10-ent-x86_64
# win-10-next-i386
# win-10-next-x86_64
# win-10-pro-x86_64
# win-11-ent-x86_64
# win-2012-x86_64
# win-2012r2-core-x86_64
# win-2012r2-fips-x86_64
# win-2012r2-wmf5-x86_64
# win-2012r2-x86_64
# win-2016-core-x86_64
# win-2016-fips-x86_64
# win-2016-x86_64
# win-2016-x86_64-ipv6
# win-2019-core-x86_64
# win-2019-fr-x86_64
# win-2019-ja-x86_64
# win-2019-x86_64
# win-2022-x86_64
# win-7-x86_64
# win-81-x86_64
#
# in case you want to update the available images map and get more windows versions

available_images_map="server-2022:win-2022-x86_64,server-2019:win-2019-x86_64,server-2016:win-2016-x86_64,server-2012R2:win-2012r2-x86_64"

# Check if the required parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <WIN_OS>"
  exit 1
fi

# Read the first argument and determine the image to use
requested_image_key=$1
image_to_use=$(echo $available_images_map | tr ',' '\n' | grep "^${requested_image_key}:" | cut -d':' -f2)

if [ -z "$image_to_use" ]; then
  echo "Invalid image key provided. Available keys are: $(echo $available_images_map | tr ',' '\n' | cut -d':' -f1 | tr '\n' ' ')"
  exit 1
fi

fqdn=""

# First lets provision through vmfloaty
if floaty get "$image_to_use" --priority 1 >"tmp/$1.txt"; then
  # Get the fqdn of the node
  fqdn=$(grep -oE '[a-zA-Z0-9-]+\.delivery\.puppetlabs\.net' "tmp/$1.txt")
  # Check if fqdn is empty
  if [ -z "$fqdn" ]; then
    echo "No matching FQDN found in tmp/$1.txt"
    exit 1
  fi
else
  echo "Failed to provision $image_to_use"
  exit 1
fi

# get the password of vmpooler by reading the .pooler_password file
pass=$(cat .pooler_password)

echo "Lets bootstrap the node"
bolt plan run bootstrap --project ./windows/bootstrap --no-host-key-check -t "winrm://$fqdn" -u Administrator --password "$pass" --no-ssl
