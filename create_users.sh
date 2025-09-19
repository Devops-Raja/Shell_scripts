#!/bin/bash

# Variable: Format: username,password (with header for data lines)
FILE="users.csv"
# Check if the CSV file exists
if [ ! -f "$FILE" ] ; then
    echo "CSV file is not present"
    exit 1
fi

# Read CSV file, skipping the first line (header)
# delimeter IFS="," read -r username password' splits each line into username and password
# ------------------------------
tail -n +2 "$FILE" | while IFS=',' read -r username password; do

    echo "Username: $username"
    echo "Password: $password"
    
    # Create a new user with home directory
    sudo useradd -m "$username"
  
    echo "$username:$password" | sudo chpasswd

    # Print confirmation
    echo "User $username created"
done
