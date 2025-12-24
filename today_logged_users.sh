#!/bin/bash

# Output file location
OUT_FILE="/tmp/todays_logged_in_users.txt"

# Get today's logged-in users and save to file
last -F | grep "$(date +%b\ %e)" | awk '{print $1}' | uniq > "$OUT_FILE"

# Confirmation message
echo "Today's logged-in users have been saved to:"
echo "$OUT_FILE"
