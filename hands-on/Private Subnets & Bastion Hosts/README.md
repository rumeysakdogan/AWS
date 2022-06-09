Private Subnets and Bastion Hosts:

Objective: Deploy an EC2 instance in a public subnet as a bastion host and then use that to jump to an EC2 instance in our private subnet.

Use the default VPC in this case, which already has a public subnet.

And we already have a route table correctly configured and an internet gateway attached to the VPC.

What we then need to do is create a private subnet with a route table, and then we're going to be able to launch our instances in the appropriate subnets and then connect in and jump from our public instance
to our private instance.

I'm in the VPC management console here, which you can find on the services.Just scroll down to networking and content delivery and VPC.

Region:  North Virginia.

VPC is a regional service.

So we have VPCs here under your VPCs.

And this is the default VPC. Every single region will have a default VPC.

The default VPC will have a subnet in each availability zone.

So we have six subnets here because US East North Virginia has six availability zones.
us-east-1a
us-east-1b
us-east-1c
us-east-1d
us-east-1e
us-east-1f

If I scroll all the way across here, I can see that your auto-assign public IP addresses configuration setting is set to yes for all of these.

These are public subnets.

Now, if I go to route tables, we'll find there's one route table for that default VPC.

This route table has a route for the actual CIDR block, so the overall address block, the IPv4 address block for the VPC of locals.

Remember, that means that it's going to route within the VPC. And then it has the IP address block for all other addresses via the internet gateway. You can find your internet gateway here. And this one is attached to our specific default VPC. So, all of that is set up for us.

Now what I want to do is create our private subnet.

So firstly, I need to know the IPv4 address block to use for this particular subnet.

It has to be within the overall CIDR block for the VPC.

It CIDR stands for Classless Inter-Domain Routing.

When we look at these IP addresses, we can see that they all start with 172.31 and then it's different.

We have .0, .16, .32, .64, and .80. And then it's a .0/20, and that's

the subnet mask.

Now I'm going to copy this one to my clipboard just to make life easier and click on create subnet.And what I'm going to do is choose my VPC,

scroll down to where it says IPv4 CIDR block.

Paste us in and then I'm going to delete the 80 and I know that the next address range is 96. So, I'm going to add that in. Now, I want to give the subnet a name.

I want to know that it's private, so I'm going to call it Private.

I want to know which VPC it's connected to,

So I'm going to put -DEF for default. And I want to know which availability zone. I'm going to put

1A(check your default VPC's availability zone, make sure you create your private subnet in the same AZ) here and then choose the availability zone.

So now from the name, I know some important information about the subnet. You can then add new subnets under add more.

But I'm just going to create this particular subnet. So that subnet is created.We've got a filtered view here.

And if I scroll all the way across, you can see the auto assigned public IPv4 is no.So we're not going to get a public IP address. So that's the correct setting for a private subnet.

Now also, we want to associate this subnet with a route table that does not have an internet gateway.

At the moment it's actually going to be associated with a public subnet routing table, the one that does have an internet gateway. And that's an implicit association.

We haven't explicitly defined that it should be associated with that route table but there's no other option, so the default route table is chosen.

So what we're going to do is create a route table.

We're just going to give this a name.I'm going to call it Private-RT.

Select my VPC and then just create the route table. Now I can go to subnet associations.

Choose edit subnet associations.And I'm going to select my private

subnet and click on save.

So now when we look at the subnet associations, we should see an explicit subnet association with our private subnet.

Launch two instances calles as Public and Private:

1) Public instance

Linux 2 AMI, t2.micro.

choose a public subnet which is in same AZ like your default VPC.

So we should see that the auto assigned public IP under subnet setting is enabled.

Security Group ---> port 22

2) Private instance:

Linux 2 AMI, t2.micro.

This time choose a private subnet you have created.

So we should see that the auto assigned public IP under subnet setting is enabled.

Security Group ---> port 22


And what we're going to do is connect from our computers through our internet gateway to the public IP of this instance and then from there to this instance.

Now there's one problem, and that is that I have my key pair file on my computer, which means I can connect to this instance.

Remember, I need to present my key pair file in order to be able to connect to this instance.

But this instance does not have a copy of that key file.

So how can we connect from here to here?

It's not going to allow that connection unless we have that particular key file available that we can

present when we're connecting with SSH.

So there is a way that we can do that and it's called agent forwarding, which I'm going to show you how to do now.

To use agent forwarding,we need to follow a particular process.
reference: https://digitalcloud.training/ssh-into-ec2-in-private-subnet/

And what we need to do is we're going to run this command ssh-add, and that's going to add our private key file to SSH so that it can then be used in subsequent commands.

command: ssh-add -K "FirstKey.pem" 

And that means we're able to then connect to our public instance and we'll still have the key file stored in memory that we can then use to connect to our private instance.

And now, I can connect to my EC2 instance.
command: ssh -A ec2-user@<publicIPv4_address_of_PublicEC2_instance>

So, I'm on the public instance, and now I want to be able to connect to my private instance. Back in

command: ssh ec2-user@<privateIPv4_address_of_PrivateEC2_instance> 

I have not specified a private key file here.

I'm just going to try and connect. And let's see.

And that worked.So that's how you can use a bastion host.
