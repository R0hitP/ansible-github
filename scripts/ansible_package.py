import boto3
import pandas as pd
import yaml
import os

# Assume the role and get temporary credentials
sts_client = boto3.client('sts')
assumed_role_object = sts_client.assume_role(
    RoleArn="arn:aws:iam::717192483375:role/cpe-admins-role",
    RoleSessionName="AssumeRoleSession1"
)

# Extract the temporary credentials
credentials = assumed_role_object['Credentials']
access_key = credentials['AccessKeyId']
secret_key = credentials['SecretAccessKey']
session_token = credentials['SessionToken']

# Create a new session using the temporary credentials
assumed_role_session = boto3.Session(
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
    aws_session_token=session_token
)

# Create the S3 client using the assumed role session
s3_client = assumed_role_session.client('s3')

# AWS S3 configuration
bucket_name = 'aws-test-compliance-report-s3-bucket'
filtered_key = 'inspector_finding/aws-test-inspector-report.csv'
filtered_download_path = '/tmp/filtered-findings-report.csv'

# Download the filtered CSV file from S3
s3_client.download_file(bucket_name, filtered_key, filtered_download_path)
print(f"Downloaded filtered report from S3 to {filtered_download_path}")

# Read the filtered CSV file
df = pd.read_csv(filtered_download_path)

# Create a list from the relevant data
affected_packages_list = []
for index, row in df.iterrows():
    affected_packages = row['Affected Packages'].split(', ')  # Assuming packages are comma-separated
    affected_packages_list.extend(affected_packages)

# Remove duplicates
affected_packages_list = list(set(affected_packages_list))

# Convert the list to a YAML format with '---' at the top
ansible_yaml = yaml.dump({'affected_packages': affected_packages_list}, default_flow_style=False)
ansible_yaml = f"---\n{ansible_yaml}"

# Path to the Ansible variable file
current_dir = os.getcwd()
ansible_var_file = os.path.join(current_dir, 'ansible-vars.yml')

# Write the YAML to a file
with open(ansible_var_file, 'w') as file:
    file.write(ansible_yaml)

print(f"Ansible variable file created at {ansible_var_file}")
