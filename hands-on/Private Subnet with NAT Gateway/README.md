[HOL] Private Subnet with NAT Gateway

Objective: Deploy a NAT gateway, so EC2 instance in a private subnet can connect to the internet.

we set up our VPC with a private subnet.

We configure our route table and then we deploy an instance into our private subnet, one into our public subnet,

and then we used agent forwarding to connect to the instance in our private subnet.

So basically, our configuration is we've got a private instance and we jump to that from an instance in the public subnet.

We can't see that in this diagram, but it's there.

So you should now have a command line on this EC2 instance.

I'm still connected to my instance here. And I know that if I try to ping an internet address like

Google.com, it's not going to work. We can see that resulted in 100% packet loss.

So basically, it didn't work at all.

So what we need to do now is deploy our NAT gateway into a public subnet, update the route table in the private subnet with a NAT gateway ID, and then we should be able to connect to the internet outbound only via the NAT gateway.

In my VPC dashboard here,

I'm in the same region as before, North Virginia.

Let's head down to NAT gateways and create a NAT gateway.

I'll simply call this my-NAT-GW. And let's select a subnet(you have to choose same public subnet mine was us-east-1b before).

Now remember, we want it to be in a public subnet. So I'm going to choose my 1A subnet that's in the public.

Remember, all of these subnets here that were created by default are public subnets, whereas this one here is the one we created ourselves and that's a private subnet.

So I'm going to deploy into a public subnet.

The connectivity type is going to be public.

We're using Network Address Translation to connect to the internet.

You can do it between different address ranges within AWS as well

if you choose a private connectivity type.

So with public selected, we need to allocate an elastic IP.

Now, I don't have any associated with my account, so let's just allocate the elastic IP and then create our NAT gateway.

So that's being created. It should only take a few minutes.

Now what we need to do is go to our route table for our private subnet.

So this is this one here. Let's go to routes.

Edit routes.

And we need to add a route.

And this is going to be for the internet.

So we're going to use 0.0.0.0/0(Anywhere)

And here, if we just click in the box, choose NAT gateway, and it's going to autofill our NAT gateway ID for us.

We can then save changes.

That's the configuration.

We don't need to do anything else.

Now, you will, of course, need to make sure that your instance has a security group associated with it that allows outbound access.

Our security group should have that, but let's just go and check.

So, back in instances here, I can see this is my instance in the private subnet.

If I go to security, I can see the security group is called web access.

Let's click on that. In our security group,let's choose outbound rules.

Now we see we have a rule here that allows all traffic, all protocols, and all port ranges outbound to any destination address.

So that should cover everything including the protocol ICMP, the Internet Control Message Protocol, which is what our ping attempt is actually trying to use.

So the security group looks good.

Let's come back to the command line and I'm just going to run that same command again. Ping Google.com.

And this time we can see we're getting a response. And I'll end it there. And we can see I got 0% packet loss, so complete success.

So, this is really useful where you need to enable outbound access for your instances. Often that's going to be to a pull down, binaries, software or software updates from the internet or connecting to some kind of API service or any service really on the internet.

Remember, the key is, this is for outbound only. You cannot have inbound access via a NAT gateway.

So that's it for this lesson, and we should clean up now because we don't need these resources anymore.

