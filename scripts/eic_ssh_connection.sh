#!/bin/bash

csv_file="/tmp/filtered-findings-report.csv"
awk  'BEGIN{ FS=",";OFS=","}{if (NR>1) print $1}' "$csv_file" | while read instanceId; do
output=$(aws ec2-instance-connect send-ssh-public-key --instance-id ${instanceId} --region us-east-1 --instance-os-user ssm-user --ssh-public-key file://~/.ssh/id_rsa.pub --profile trainee)
echo "$output"
done

#need to remove duplicates
#issue arise if there are instances that are not running in the csv