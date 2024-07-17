#!/bin/bash
# Define CSV file path and SSH public key location
csv_file="/tmp/filtered-findings-report.csv"
ssh_key_file="~/.ssh/id_rsa.pub"

# Validate file existence
if [[ ! -f "$csv_file" ]]; then
echo "Error: CSV file '$csv_file' not found!"
exit 1
fi

if [[ ! -f "$ssh_key_file" ]]; then
echo "Error: SSH public key file '$ssh_key_file' not found!"
exit 1
fi

# Specify region and instance OS user
region="us-east-1"
instance_os_user="ssm-user"
profile="UserR"

# Extract instance IDs (using awk with uniq)
instance_ids=$(awk -F',' '{if (NR>1) print $1}' "$csv_file" | sort | uniq)
for instance_id in $instance_ids; do
# Execute AWS CLI command with error handling 
echo "applying chnages for instance '$instance_id'"
# Execute AWS CLI command with error handling
aws ec2-instance-connect send-ssh-public-key \
    --instance-id "$instance_id" \
    --region "$region" \
    --instance-os-user "$instance_os_user" \
    --ssh-public-key "file://$ssh_key_file" \
    --profile "$profile" || {
    echo "Error adding SSH key to instance '$instance_id'"
    # Continue processing remaining instances
}
done

echo "Successfully added SSH public key to instances!"