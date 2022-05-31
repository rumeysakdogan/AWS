# AWS CLI
# Altaz - 02_21_2022

# References
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
# https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
# https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/



# Installation

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Win:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


# Mac:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# https://graspingtech.com/install-and-configure-aws-cli/


# Linux:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# Update AWS CLI Version 1 on Amazon Linux (comes default) to Version 2

# Remove AWS CLI Version 1
sudo yum remove awscli -y # pip uninstall awscli/pip3 uninstall awscli might also work depending on the image

# Install AWS CLI Version 2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip  #install "unzip" if not installed
sudo ./aws/install

# Update the path accordingly if needed
export PATH=$PATH:/usr/local/bin/aws


############# Configuration #################

# 1. Get your AWS Access Key ID and Secret Access Key from the AWS IAM Console
#   a. your access key id will be visible
#   b. delete your existing secret key (if it exists) and create a new secret key
#   c. save both these values to a temporary file

# 2. At the command prompt, type
aws configure

# 3. Enter the following information when prompted:
#       AWS Access Key ID [None]: <Paste your access Key>
#       AWS Secret Access Key [None]: <Paste your secret Key>
#       Default region name [None]: us-east-1
#       Default output format [None]: json

# 4. Open the following files and view them:
#       <home>/.aws/config
#       <home>/.aws/credentials

# 5. At the command prompt, type:
aws configure --profile user1
#
# enter the same information as 3 above EXCEPT
# use us-east-2 for the region

# 6. Using different profiles
#       a. At the command prompt, type:
aws configure get region --profile default
aws configure get region --profile user1

#       b. At the command prompt, type:
set AWS_PROFILE=user1 (Windows)
export AWS_PROFILE=user1 (Mac)
# then type:
aws configure get region
#       c. At the command prompt, type:
set AWS_PROFILE=default (Windows)
export AWS_PROFILE=default (Mac)


# 7. Listing profiles.  At the command prompt, type:
aws configure list-profiles

# 8. Getting AWS caller identity:
aws sts get-caller-identity

# IAM
aws iam list-users

aws iam create-user --user-name aws-cli-user

aws iam delete-user --user-name aws-cli-user


# S3
aws s3 ls

aws s3 mb s3://<your_bucket_name>

make a copy of this file (Inclass-Notes-Altaz.sh) to your current directory

aws s3 cp InclassNotes-Altaz.sh s3://<your_bucket_name>

aws s3 ls s3://<your_bucket_name>

aws s3 rm s3://<your_bucket_name>/in-class.yaml

aws s3 rb s3://<your_bucket_name>


# EC2
aws ec2 describe-instances

aws ec2 run-instances \
   --image-id ami-033b95fb8079dc481 \
   --count 1 \
   --instance-type t2.micro \
   --key-name KEY_NAME_HERE # put your key name

aws ec2 describe-instances \
   --filters "Name = key-name, Values = KEY_NAME_HERE" # put your key name

aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress[]"

aws ec2 describe-instances \
   --filters "Name = key-name, Values = KEY_NAME_HERE" --query "Reservations[].Instances[].PublicIpAddress[]" # put your key name

aws ec2 describe-instances \
   --filters "Name = instance-type, Values = t2.micro" --query "Reservations[].Instances[].InstanceId[]"

aws ec2 stop-instances --instance-ids INSTANCE_ID_HERE # put your instance id

aws ec2 terminate-instances --instance-ids INSTANCE_ID_HERE # put your instance id

# Working with the latest Amazon Linux AMI

# https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/
# https://aws.amazon.com/blogs/mt/query-for-the-latest-windows-ami-using-systems-manager-parameter-store/


aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1

aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text

aws ec2 run-instances \
   --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 
'Parameters[0].[Value]' --output text) \
   --count 1 \
   --instance-type t2.micro

# Time Permitting

# Install AWS CLI v2 on Amazon Linux 2
# Deploy CFT from last lesson
