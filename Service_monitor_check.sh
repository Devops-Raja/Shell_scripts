#!/bin/bash
# Array of services to be checked
services=("nginx" "sshd" "kafka")

echo "======================================"
echo "   SERVICE STATUS CHECK & AUTO-RESTART "
echo "======================================"

# Loop through each service in the array
for service in "${services[@]}"; do
    # Check if the service is currently running
    
    if systemctl is-active --quiet "$service"; then
        echo " $service is already RUNNING"
        

    else
        echo " $service is NOT running"
        echo " Attempting to restart $service..."
       # Try restarting the stopped service
        systemctl restart "$service"

        # Check again after restart attempt
        if systemctl is-active --quiet "$service"; then
            echo "$service restarted SUCCESSFULLY"
        else
            echo " FAILED to restart $service"
            echo " Manual intervention required"
        fi
        echo   # this empty echo is used for empty line 
    fi

done

echo "======================================"
echo "Service check completed"
echo "======================================"
