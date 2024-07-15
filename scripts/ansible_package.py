import boto3
import pandas as pd
import yaml
import os

# Set the AWS profile to "trainee"
os.environ['AWS_PROFILE'] = 'trainee'

# AWS S3 configuration
bucket_name = 'aws-test-compliance-report-s3-bucket'
filtered_key = 'inspector_finding/aws-test-inspector-report.csv'
filtered_download_path = '/tmp/filtered-findings-report.csv'

# Create the S3 client
s3_client = boto3.client('s3')

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

# Convert the list to a YAML format
ansible_yaml = yaml.dump({'affected_packages': affected_packages_list}, default_flow_style=False)

# Path to the Ansible variable file
current_dir = os.getcwd()
ansible_var_file = os.path.join(current_dir, 'main.yml')

# Write the YAML to a file
with open(ansible_var_file, 'w') as file:
    file.write(ansible_yaml)

print(f"Ansible variable file created at {ansible_var_file}")

# Clean up local files if needed
if os.path.exists(filtered_download_path):
    os.remove(filtered_download_path)
    print(f"Deleted temporary filtered CSV file {filtered_download_path}")
