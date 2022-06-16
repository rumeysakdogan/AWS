# Hands-on VPC-03 : 

## Part 5 - Creating VPC peering between two VPCs (Default and Custom one)

## STEP 1 : Prep---> Launching Instances


- Launch two Instances. First instance will be in "clarus-az1a-private-subnet" of "clarus-vpc-a",and the other one will be in your "Default VPC". 

- In addition, since the private EC2 needs internet connectivity to set user data, we also need NAT Gateway.

### A. Configure Public Windows instance in Default VPC.

```text
AMI             : Microsoft Windows Server 2019 Base
Instance Type   : t2.micro
Network         : Default VPC
Subnet          : Default Public Subnet
Security Group  : 
    Sec.Group Name : WindowsSG
    Rules          : RDP --- > 3389 ---> Anywhere
Tag             :
    Key         : Name
    Value       : Public-Windows

PS: For MAC, "Microsoft Remote Desktop" program should be installed on the computer.
```

### B. Since the private EC2 instance needs internet connectivity to set user data, first create NAT Gateway

- Click Create Nat Gateway button in left hand pane on VPC menu

- click Create NAT Gateway.

```bash
Name                      : clarus-nat-gateway

Subnet                    : clarus-az1a-public-subnet

Elastic IP allocation ID  : Allocate Elastic IP
```
- click "Create Nat Gateway" button

### C. Modify Route Table of Private Instance's Subnet

- Go to VPC console on left hand menu and select Route Table tab

- Select "clarus-private-rt" ---> Routes ----> Edit Rule ---> Add Route
```
Destination     : 0.0.0.0/0
Target ----> Nat Gateway ----> clarus-nat-gateway
```
- click save changes

WARNING!!! ---> Be sure that NAT Gateway is in active status. Since the private EC2 needs internet connectivity to set user data, NAT Gateway must be ready.


### D. Configure Private instance in 'clarus-az1a-private-subnet' of 'clarus-vpc-a'.

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a 
Subnet          : clarus-az1a-private-subnet
user data       : 

#!/bin/bash

yum update -y
amazon-linux-extras install nginx1.12
cd /usr/share/nginx/html
chmod o+w /usr/share/nginx/html
rm index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/index.html
wget https://raw.githubusercontent.com/awsdevopsteam/route-53/master/ken.jpg
systemctl enable nginx
systemctl start nginx

Security Group    : 
    Sec.Group Name : PrivateSG
    Rules          : SSH  ---> 22 ---> Anywhere
                     HTTP ---> 80 ---> Anywhere
                     All ICMP IPv4 ---> Anywhere
    
Tag             :
    Key         : Name
    Value       : Private-Instance
```

- Go to instance named 'Public-Windows' and hit the connect button ----> Download Remote Desktop File

- Decrypt your ".pem key" using "Get Password" button
  - Push "Get Password" button
  - Select your pem key using "Choose File" button ----> Push "Decrypt Password" button
  - copy your Password and paste it "Windows Remote Desktop" program as a "administrator password"

- Open the internet explorer of windows machine and paste the private IP of EC2 named 'Private-Instance'

- It is not able to connect to the website 


## STEP 2: Setting up Peering


- Go to 'Peering connections' menu on the left hand side pane of VPC

- Push "Create Peering Connection" button

```text
Peering connection name tag : First Peering
VPC(Requester)              : Default VPC
Account                     : My Account
Region                      : This Region (us-east-1)
VPC (Accepter)              : clarus-vpc-a
```
- Hit "Create peering connection" button

- Select 'First Peering' ----> Action ---> Accept Request ----> Accept Request

- Go to route Tables and select default VPC's route table ----> Routes ----> Edit routes
```
Destination: paste "clarus-vpc-a" CIDR blok
Target ---> peering connection ---> select 'First Peering' ---> Save routes
```

- select clarus-private-rt's route table ----> Routes ----> Edit routes
```
Destination: paste "default VPC" CIDR blok
Target ---> peering connection ---> select 'First Peering' ---> Save routes
```

- Go to windows EC2 named 'Public-Windows', write the private IP address of the Private-Instance on browser and show the website with KEN.


WARNING!!! ---> Please do not terminate "NAT Gateway" and "Private-Instance" for next part.


## Part 6 - Create VPC Endpoint

# STEP 1: 

### A. Create S3 Bucket 

- Go to the S3 service on AWS console
- Create a bucket of `clarusway-vpc-endpoint` with following properties, 

```text
Object Ownership            : ACLs disabled
Block all public access     : Checked
Versioning                  : Disabled
Server access logging       : Disabled
Tags                        : 0 Tags
Default encryption          : Disabled
Object lock                 : Disabled

```
- Upload 'Honda.png' file into the S3 bucket

### B. Configure Public Instance (Bastion Host)

```text
AMI             : Amazon Linux 2
Instance Type   : t2.micro
Network         : clarus-vpc-a
Subnet          : clarus-az1b-public-subnet
Security Group    : 
    Sec.Group Name : PublicSG
    Rules          : SSH --- > 22 ---> Anywhere
Tag             :
    Key         : Name
    Value       : Public-Instance (Bastion Host)
```

### C. Create IAM role to reach S3 from "Private-Instance"

- Go to IAM Service from AWS console and select roles on left hand pane

- click create role
```
Trusted entity type: AWS Service
use case : EC2  
Use cases for other AWS services: s3 ---> Next : Permission
Permissions Policies: AmazonS3FullAccess ---> Next
Role Name : clarusS3FullAccessforEndpoint
Role description: clarus S3 Full Access for Endpoint
click create button
```
Go to EC2 service from AWS console

Select "Private-Instance" ---> Actions ---> Security ---> Modify IAM Role  select newly created IAM role named 'clarusS3FullAccessforEndpoint' ---> Apply

# STEP 2: Access S3 Bucket from Private-Instance

### A. Connect to the Bastion host

- Go to terminal and connect to the Bastion host named 'Public-Instance (Bastion Host)'

- Using Bastion host connect to the EC2 instance in "private subnet" named 'Private-Instance ' (using ssh agent or copying directly pem key into the EC2)

- Start the ssh-agent in the background

```bash
eval "$(ssh-agent)"
```
- Add your private key to the ssh agent on your computer `localhost`.

```bash
ssh-add ./[your pem file name]
```
- connect to the ec2 instance (Public-Instance (Bastion Host)) in clarus-az1b-public-subnet
```bash
ssh -A ec2-user@ec2-3-88-199-43.compute-1.amazonaws.com
```
### B.Connect to the Private Instance

- once logged into the bastion host connect to the private instance in the private subnet:
```bash
ssh ec2-user@[Your private EC2 private IP]
```
### C. Use CLI to verify connectivity

- list the bucket in S3 and content of S3 bucket named "aws s3 ls "clarusway-vpc-endpoint" via following command

```
aws s3 ls
aws s3 ls clarusway-vpc-endpoint
```

- go to NAT Gateways on VPC service

- select clarus-nat-gateways ---> Actions ---> Delete NAT Gateway

- Go to the terminal and try to connect again S3 bucket via following command
```
aws s3 ls
```
- show that you are "not able to connect" to the s3 buckets list


## STEP 3: Create Endpoint

### A. Connect  to S3 via Endpoint

- go to the Endpoints menu on left hand pane in VPC

- click Create Endpoint
```text
Name             : clarus-s3-endpoint
Service Category : AWS services
Service Name     : com.amazonaws.us-east-1.s3
Service Type     : gateway
VPC              : clarus-vpc-a
Route Table      : choose private one or both 
```
- Create Endpoint

- Go to private route table named 'clarus-private-rt' and show the endpoint rule that is automatically created by AWS 

### B. Connect to S3 via Endpoint

- Go to terminal, list the buckets in S3 and content of S3 bucket named "clarusway-vpc-endpoint" via following command
```bash
aws s3 ls
aws s3 ls clarusway-vpc-endpoint
```

- copy the 'Honda.png' file from S3 bucket into the private EC2
```bash
aws s3 cp s3://clarusway-vpc-endpoint/Honda.png .
```


**Don't forget to terminate the resources you've created!!!!!!!**










