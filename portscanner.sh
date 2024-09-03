#!/bin/bash

# Define the filenames
hostfile="mytargets.txt"
portfile="mytcpports.txt"

# Assign socket connection error file
errfile="/tmp/portscan_err"

# Verify the input arguments
if [ ! -f "$hostfile" ]; then
  echo "Error: hostfile '$hostfile' does not exist"
  exit 1
fi

if [ ! -f "$portfile" ]; then
  echo "Error: portfile '$portfile' does not exist"
  exit 1
fi

echo "host,port"

# Clear previous error file
> "$errfile"

# Loop through hosts and ports
for host in $(cat "$hostfile"); do
  for port in $(cat "$portfile"); do
    # Try to connect to the host and port, log any errors
    if timeout 1 bash -c "echo >/dev/tcp/$host/$port" 2>>"$errfile"; then
      echo "$host,$port"
    fi
  done
done

# Check for presence of stderr and handle errors
if [ -s "$errfile" ]; then
  echo "Presence of errors from connections!"
  cat "$errfile"
  rm "$errfile"
  exit 1
fi

# Clean up the error file if no errors
rm -f "$errfile"
