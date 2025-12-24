#!/bin/bash

# Define the size threshold
SIZE_LIMIT="+100M"

# Directory to scan
TARGET_DIR="/var"

###############################################################################
# Step 1: Find files larger than 100 MB
###############################################################################
echo " Searching for files larger than 100MB in $TARGET_DIR..."
echo
find "$TARGET_DIR" -type f -size "$SIZE_LIMIT" -exec ls -lh {} \;

echo
echo "----------------------------------------------"

###############################################################################
# Step 2: Identify the largest file in /var
###############################################################################
echo " Identifying the largest file in $TARGET_DIR..."

largest_file=$(find "$TARGET_DIR" -type f -exec du -h {} + | sort -rh | head -1)

echo "🏆 Largest file:"
echo "$largest_file"


###############################################################################
# Step 3: Deleting files larger than 100 MB
###############################################################################

# Directory to search
DIR="/var"

echo "========================================"
echo " Finding files larger than 100MB in $DIR"
echo "========================================"


find "$DIR" -type f -size +100M -print -exec rm -i {} \;

echo
echo "========================================"
echo " Cleanup completed"
echo "========================================"


