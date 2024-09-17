#!/bin/bash

# Define the filenames
host=$1
srv=$2

echo "DNS resolution for $host"

for i in {1..254}
do
 nslookup $host.$i $srv | grep "name = "
done
