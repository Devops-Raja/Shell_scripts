### Demo Shell script for Track the AWS resourece Usage ###

#!/bin/bash

set -eE    # Exit immediately if any command fails

### AWS Resource Tracker ###
#--------------------------------------------------
REPORT_DIR= "$HOME/aws_reports"  #Directory path
mkdir -p "$REPORT_DIR"   # Create if Directory not present
S3_BUCKET="my-aws-reports-bucket"    # Already existing s3 bucket
EMAIL_TO="team@example.com"
TIMESTAMP=$(date)
REPORT_FILE="$REPORT_DIR/aws_report_$TIMESTAMP.txt"
#--------------------------------------------------

#---------- CleanUp Function ----------------------

cleanup() {
	echo "[$(date)] script Ended. CleanUp Done."
}

error_handler() {
	echo "[$(date)] Error occured at line $LINENO " >> "$REPORT_FILE"
	exit 1
}

trap cleanup EXIT SIGTERM SIGINT
trap error_handler ERR

#----------------------------------------------------

echo "AWS REPORT" > "$REPORT_FILE"
echo "Generated on $TIMESTAMP" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"


### EC2 Details ###

{
aws ec2 describe-instances --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,Type:InstanceType,AZ:Placement.AvailabilityZone}' --output table 
echo "" 
} >> "$REPORT_FILE"

### S3 Bucket ###
{
aws s3 ls >> "$REPORT_FILE"
echo "" 
} >> "$REPORT_FILE"

### AWS LAMBDA ###
{
aws lambda list-functions --query 'Functions[].{FunctionName:FunctionName,Runtime:Runtime,LastModified:LastModified}' --output table 
echo ""  
echo "Report completed successfully."
} >> "$REPORT_FILE"

# --------------------------------------------------
# COST ESTIMATION (LAST 30 DAYS)
# -----------------------------
{
echo "AWS COST ESTIMATION (Last 30 Days)"
START_DATE=$(date -d "-30 days" +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)

aws ce get-cost-and-usage \
 --time-period Start=$START_DATE,End=$END_DATE \
 --granularity MONTHLY \
 --metrics "UnblendedCost" \
 --query 'ResultsByTime[].Total.UnblendedCost.Amount' \
 --output text | awk '{print "Total Cost (USD): $"$1}'

echo ""
} >> "$REPORT_FILE"

# -----------------------------
# UPLOAD REPORT TO S3

aws s3 cp "$REPORT_FILE" "s3://$S3_BUCKET/"  ## upload to s3 bucket

# EMAIL REPORT
# -----------------------------
mail -s "AWS Resource & Cost Report - $TIMESTAMP" "$EMAIL_TO" < "$REPORT_FILE"


echo "Report generated: $REPORT_FILE"
echo "Uploaded to S3 bucket: $S3_BUCKET"
echo "Email sent to: $EMAIL_TO"

================================================================================================================================

Integrating cronjob to run script :

0 9 * * * /path/aws_resource_tracking.sh

Script runs daily at 9AM.


================================================================================================================================
