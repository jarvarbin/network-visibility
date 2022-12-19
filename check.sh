

#!/bin/bash

# Set the base IP address and subnet mask
base_ip="10.244.1.73"
subnet_mask="255.255.255.0"

# Calculate the number of possible hosts in the subnet
hosts=$((2**(32-$(echo "$subnet_mask" | awk -F'[.]' '{print $1,$2,$3,$4}' | awk '{print ($1+$2+$3+$4)}'))))

# Iterate over all possible hosts in the subnet
for i in $(seq 1 "$((hosts-1))"); do
  # Calculate the current host IP address
  host_ip=$(ipcalc "$base_ip/$subnet_mask" | grep HostMin | awk '{print $2}' | cut -d/ -f1 | awk -F'[.]' '{print $1"."$2"."$3"."$4+'$i'}')
  
  # Try to ping the current host
  response=$(ping -c 1 -W 2 "$host_ip" > /dev/null 2>&1)
  
  # Check the response and write the result to the text file
  if [ "$response" -eq 0 ]; then
    echo "$host_ip is up" >> network_visibility.txt
  else
    echo "$host_ip is down" >> network_visibility.txt
  fi
done
