# Hands-on Security WAF : Working with AWS WAF and Application Load Balancers

Purpose of this hands-on training is to get exposure to AWS WAF.  We'll cover how to attach WAF Web ACLs to an Application Load Balancer
and prevent undesired traffic getting through to servers behind the WAF.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- create an Application Load Balancer and it's components

- create AWS WAF ACLs

- attach a WAF ACL to a Load Balancer

- limit traffic getting through to the servers behind a load balancer

## Outline

- Part 1 - Create an Application Load Balancer and a web server behind it

- Part 2 - Explore rules for AWS WAF

- Part 3 - Create an ACL to block a single IP

- Part 4 - Create an ACL to block repeated requests from the same IP


## Part 1 - Build an Application (Security Group, ALB, Web Servers)

`### Step 1 - Create a Security Group:`

- Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/

- Choose Security Groups on the left-hand menu

- Click the "Create Security Group" tab.

```text
Security Group Name : ALB-EC2-SG
Description         : ALB and EC2 Security Group
VPC                 : Default VPC
Inbound Rules:
    - Type: SSH  ---> Source: Anywhere
    - Type: HTTP ---> Source: Anywhere
Outbound Rules: Keep it as it is
Tag:
    - Key   : Name
      Value : ALB-EC2-SG
```

`### Step 2 - Create a Web Server:`

- Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/

- Choose Instances on the left-hand menu

- Click on 'Launch Instances'

```text
- Amazon Machine Image (AMI):   Amazon Linux 2 AMI (HVM), SSD Volume Type
- Instance Type:                t2.micro
- Network:                      Select your default VPC
- Subnet:                       Select a public subnet
- Auto-assign Public IP:        Enabled
- User data:                    Paste the text from the script below
```
```bash
#!/bin/bash -x

#update os
yum update -y

#install apache server
yum install -y httpd

# create a custom index.html file
chmod -R 777 /var/www/html
echo "<html>
<head>
    <title> Web Server Running in AWS</title>
</head>
<body>
    <h1>This web server is protected by AWS WAF</h1>
</body>
</html>" > /var/www/html/index.html

# start apache server
systemctl start httpd
systemctl enable httpd
```
```text
Storage:            select the default (Volume 1 (AMI Root) (8 GiB, EBS, General purpose SSD (gp2)))
Tags:
    Key:            Name
    Value:          Web-Server
Security Group:     Select the security group created above named ALB-EC2-SG
```

- Launch the EC2 instance with your key-pair

`### Step 3 - Create a Target Group:`

- Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/

- Choose Target Groups on the left-hand menu

- Click on 'Create Target Group'

- **Basic Configuration**
```text
Target Type:        Instances
Target group name:  MyTargetGroup
Protocol:           HTTP
Port:               80
Protocol Version:   HTTP1
```

- **Health Checks**
```text
Use Defaults
```

- Click Next

- **Register Targets**
```text
- Select the instance you created above
- Click on 'Include as pending below'
```

- Click 'Create target group'



`### Step 4 - Create an Application Load Balancer:`

- Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/

- Choose Load Balancers on the left-hand menu

- Click on 'Create Load Balancer'

- Select 'Create' under Application Load Balancer

- **Basic Configuration**
```text
Load balancer name: MyLoadBalancer
Scheme:             Internet Facing
IP Address Type:    IPV4
```

- **Network Mapping**
```text
VPC:                Select your default VPC (same as that selected for EC2 instance above)
Mappings:           Select all availability zones
```

- **Security Groups**
```text
Security Groups:    Select the security group created above named ALB-EC2-SG (delete any others)
```

- **Listeners and Routing**
```text
Protocol:           HTTP
Port:               80
Default Action:     Forward to MyTargetGroup (target group created above)
```

- Click on Create Load Balancer


`### Step 5 - Check that you can access your Web Server:`

- Use the DNS name under the EC2 console and copy the name into a browser using http; i.e. http://dns-name

- Go to the load balancer console and ensure your load balancer is in the 'active state'

- Select the load balancer DNS and enter the name into a browswer using http; i.e. http://load-balancer-dns-name

- Both URLs should show you the same web page


## Part 2 - Add WAF Protection

`### Step 1 - Explore WAF`

- Access the AWS WAF console using the URL: https://console.aws.amazon.com/wafv2/homev2 or search for it in the services search bar

- On the left side, click on "Web ACLs"

- Click on "Create web ACL"

- **Web ACL Details**
```text
Name:               MyFirstWebAcl
Description:        Protect web servers against threats
CloudWatch metric:  (Leave the default value)
Resource type:      Regional resources (Application Load Balancer, API Gateway, AWS AppSync)
Region:             US East (N. Virginia)
```

- **Associated AWS resources**

- Click on 'Add AWS Resources'

- Change the Resource Type to 'Application Load Balancer'

- Select MyLoadBalancer

- Click 'Add'

- Click 'Next'

- **Add rules and rule groups**

- **Rules**

- Select 'Add Rules' and choose 'Add Managed Rule Groups'

- Explore the different options

- Note that there are AWS Managed Rules that are Free

- Note that there are 3rd Party Managed rules which you must subscribe to

- Developing these rules is a complex task and using managed rules is a good place to start

- Click on 'Close'

- Click on 'Cancel'


`### Step 2 - Create an IP Set`

- In a browser, go to the URL https://www.whatismyip.com/

- Copy your IPv4 address

- Return to the AWS WAF Console

- On the left hand menu, select 'IP sets'

- Click on 'Create IP Set'

- **IP set details**
```text
IP set name:        MyIPSet
Description:        Block my IP
Region:             US East (N. Virginia)
IP Version:         IPv4
IP addresses:       Enter your IP address from above (add /32 at the end)
```
- Click Create IP set


`### Step 3 - Create a self-managed rule - Block your IP`

- Return to the AWS WAF main console

- Access the AWS WAF console using the URL: https://console.aws.amazon.com/wafv2/homev2 or search for it in the services search bar

- On the left side, click on "Web ACLs"

- Click on "Create web ACL"

- **Web ACL Details**
```text
Name:               MyFirstWebAcl
Description:        Protect web servers against threats
CloudWatch metric:  (Leave the default value)
Resource type:      Regional resources (Application Load Balancer, API Gateway, AWS AppSync)
Region:             US East (N. Virginia)
```

- **Associated AWS resources**

- Click on 'Add AWS Resources'

- Change the Resource Type to 'Application Load Balancer'

- Select MyLoadBalancer

- Click 'Add'

- Click 'Next'

- **Add rules and rule groups**

- **Rules**

- Click Add Rules

- Click 'Add my own rules and rule groups'

- **Add my own rules and rule groups**
```text
Rule Type:          IP set
Name:               BlockMyIP
IP set:             MyIPSet
IP address to use:  Source IP address
Action:             Block
```

- Click 'Add rule'

- Under Default web ACL action for requests that don't match any rules, make sure you select 'Allow'

- For the remaining pages, click 'Next' then click 'Create web ACL'

`### Step 4 - Test the IP Blocking Web ACL`

- Copy the DNS address for your load balancer and enter it in a browser.  What happens?

- Copy the DNS address for your EC2 server and enter it in a browser.  What happens?

- On the AWS WAF Console, select 'Web ACLs' and then click on 'MyFirstWebAcl'

- Look at the 'Sampled Requests' under the 'Overview' tab

- Explore the rest of the dashboard

- On the dashboard, select 'Associated AWS Resources', choose your load balancer and select 'Disassociate'

- Go back to the AWS WAF main console page and select 'Web ACLs'

- Select 'MyFirstWebAcl' and click 'Delete'.  Follow the instructions to delete.


`### Step 5 - Create a self-managed rule - Rate Limit`

- Return to the AWS WAF main console

- Access the AWS WAF console using the URL: https://console.aws.amazon.com/wafv2/homev2 or search for it in the services search bar

- On the left side, click on "Web ACLs"

- Click on "Create web ACL"

- **Web ACL Details**
```text
Name:               RateLimitACL
Description:        Protect web servers against repeated requests
CloudWatch metric:  (Leave the default value)
Resource type:      Regional resources (Application Load Balancer, API Gateway, AWS AppSync)
Region:             US East (N. Virginia)
```

- **Associated AWS resources**

- Click on 'Add AWS Resources'

- Change the Resource Type to 'Application Load Balancer'

- Select MyLoadBalancer

- Click 'Add'

- Click 'Next'

- **Add rules and rule groups**

- **Rules**

- Click Add Rules

- Click 'Add my own rules and rule groups'

- **Add my own rules and rule groups**
```text
Rule Type:          Rule builder
Name:               HundredMaxAttempts
Type:               Rate-based rule
Rate limit:         100 (this means max of 100 requests in 5 minutes)
```

- Note the remaining default values for your information

- Click 'Add rule'

- Under Default web ACL action for requests that don't match any rules, make sure you select 'Allow'

- For the remaining pages, click 'Next' then click 'Create web ACL'


`### Step 6 - Test the Rate Limit ACL`

- Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/

- Choose Instances on the left-hand menu

- Click on 'Launch Instances'

```text
- Amazon Machine Image (AMI):   Amazon Linux 2 AMI (HVM), SSD Volume Type
- Instance Type:                t2.micro
- Network:                      Select your default VPC
- Subnet:                       Select a public subnet
- Auto-assign Public IP:        Enabled
- Storage:                      select the default (Volume 1 (AMI Root) (8 GiB, EBS, General purpose SSD (gp2)))
- Tags:
    Key:                        Name
    Value:                      Testing server
- Security Group:               Select the security group created above named ALB-EC2-SG
```
- Launch the EC2 instance with your key-pair

- Connect to your instance via ssh

- Copy the following text into a bash script called test.sh

```bash
#!/bin/bash
for x in {1..200}
do
        output=$(curl -s http://myloadbalancer-602599660.us-east-1.elb.amazonaws.com/ | grep h1)
        echo $x - $output
        sleep 1
done
```

- Save the script

- Type chmod +x test.sh

- Run the script ./test.sh

- Notice the output

- Notice what happens shortly after the count exceeds 100 (note because of the way AWS samples, this number will go above 100)

- Explore the AWS WAF Dashboard for this WebACL



`### Step 7 - Delete your resources!`

- Delete the Load Balancer

- Delete the Target Group

- Delete the WAF Web ACL

- Delete BOTH EC2 Instances






