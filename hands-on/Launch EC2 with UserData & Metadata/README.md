[HOL] Launch Instance with User Data and Metadata

Purpose of this hands-on training how to use user data and metadata with EC2.

user-data-metadata.SH file:

#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
EC2ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) 
echo '<center><h1>The Instance ID of this Amazon EC2 instance is: EC2ID </h1></center>' > /var/www/html/index.txt
sed "s/EC2ID/$EC2ID/" /var/www/html/index.txt > /var/www/html/index.html


This is going to update the operating system with patches and then installs a web server called HTTPD, a very simple web service.

Then what's happening is it's actually going to use the metadata of the instance.

So it's going to find out what the instance ID is.

URL: curl -s http://169.254.169.254/latest/meta-data/instance-id

Above URL is actually going to find out what the instance ID is for this particular instance, and it's going to record it in a variable.

And then it's going to take that variable and put it into some text.

And so what should happen is the web page should say the instance ID of this Amazon EC2 instance is <instance_id_#> and then it should have the correct instance ID.

And the way it does that is it changes the variable and saves it to the index.HTML file, which is the web page that we're going to see when we connect to the instance.

This file is going to be supplied as user data to our EC2 instance when we launch.

So we're combining metadata to find out the instance ID and user data in terms of supplying this code to the operating system when it boots.

So let's head over to the management console.

Back in EC2, I'm going to choose launch instances.

I'm going to select Amazon Linux 2 AMI.

We'll keep it as a t2.micro.

Choose configure instance details.

And this time we scroll to the bottom, under user-data section:

And we have two options here, we could put the code directly in here or we can choose the file. So I'm going to choose the file.Select choose file.And in my code directory, I'm going to go and find that file and choose for upload.

So now the file is being supplied.

Nothing needs to be changed.

We can choose next.

Go through to security group.

We can choose our security group and then go forward.

Now, there is another thing we're going to need to do once we launch this instance.

Remember, we have two protocols that we can connect to our instance with.

The Secure Shell Protocol or RDP.

Nothing else is allowed in our security group, our firewall.

And we will need to allow port 80 because that's the port that a web server runs on.

So let's choose review and launch and launch.

I just need to acknowledge and launch instances.

So while that's launching, let's come back to the console, choose security groups.

I'm going to go back to inbound rules, edit inbound rules, click on add,

and this time I'm going to type HTTP.

Select HTTP, and it automatically chooses the port range as 80.

And we're going to allow from anywhere.

I'm going to just use IPv4 and save rules.

So that's done.

Let's go back to instances and we just need to give this a couple of minutes to make sure

that it's booted up.

And then I should be able to copy this IP address and put it into a browser window.

So just give that a couple of minutes and then we'll give it a try.

Okay, so it's been a couple of minutes.

I'm going to copy the public IPv4 address or you can choose the IPv4 DNS.

I'm going to open a new tab in my browser, paste that in and hit enter.

And sure enough we get a web page.

And the web page has the text that came from our file that says the instance ID of this Amazon

EC2 instance is

and then we can see it's filled out the instance ID.

So that should correspond with the instance ID here.

So that information was found in the metadata for the EC2 instance.

So we used the user data to install a web service and we used metadata to find out the instance ID and then we put it on this page.

So that's how we use user data and metadata.

Now, I'm just going to go back and terminate my instance.

So again, just select your instance, go to instance state and terminate instance.