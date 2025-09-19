##Log Cleanup for specific Directory

#!/bin/bash

#Variables
#Use following line for user specific directory ## read -p "Enter directory path: " LOGDIR
LOGFILE="/var/log/log_rotation_details.log"
LOGDIR="/var/log/app"  

#Check if log directory is available

if [ ! -d "$LOGDIR" ]; then
        echo "[$(date)] Error: $LOGDIR is not available in the path"
        exit 1
fi


#Compress logs older than 7 Days (Not the 30 days old logs & ignoring already compressed log )

find "$LOGDIR" -type f -name "*.log" -mtime +7 -mtime -30  ! -name "*.gz" -exec gzip {} \; -exec echo "[$(date)] 7 Days older log compressed {}" >> "$LOGFILE" \;


# Delete the logs (compressed ) older than 30 days

find "$LOGDIR" -type f -name "*.gz" -mtime +30 -exec rm {} \; -exec echo " [$(date)] 30 + days logs removed {}" >> "$LOGFILE" \;

echo "Log's are removed and the details are saved in $LOGFILE"
