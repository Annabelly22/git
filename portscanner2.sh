#!/bin/bash

# Define the filenames
host=$1
port=$2

# Assign socket connection error file
errfile="/tmp/portscan_err"

echo "ip,port"

# Clear previous error file
> "$errfile"
for i in {1..254}
do
 if timeout 1 bash -c "echo >/dev/tcp/$host.$i/$port" 2>>"$errfile"; then
      echo "$host.$i,$port"
     fi
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
