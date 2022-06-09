[HOL] Working with ENIs(Elastic Network Interfaces):


So this time we're going to have a look at working with Elastic Network Interfaces.

So let's head over to the console. On the easy to management console,

I'm going to launch an instance. Again,

it's going to be the Linux 2 AMI, t2.micro.

I'm going to put this one in public-1A(us-east-1a) and then I'm going to click on next.Go through.We don't need to change any other settings.

Just choose our web access security group and we're going to launch this instance.

So the instance is launching. Now, while that's happening,

we're going to scroll down here to network interfaces. And we can see we have an existing network interface.

Let's just pull this box up from the bottom here. And we can see a bit more information.

We can see the interface ID. We can see it's in use, what VPC and subnet it's in, and we can see the address information here as well.

And you can say it's not an Elastic Fabric Adaptor. We know what availability zone it's in.

This is quite a bit of information here.You can also see the Mac address, so that's the layer two address associated with this particular ENI.

What I want to do is create a new network interface.

I'm going to call this eth1 because it's essentially the second interface for instance. And I need to put it in the same subnet because I want to attach it to the instance we've just launched.

Now remember, you can attach an interface in a different subnet as long as the subnet is in the same AZ.

So we're going to choose public-1A(us-east-1a)

We're going to leave the default settings for IP addresses and choose Web Access Security Group and then create the network interface.

So that's done. Let's select this interface.

We can see it's available, it's not in use, and we can see some information.

We can see that it has a V6 address, a V4 address, and DNS names as well.

So now let's go up to actions. Choose attach.

And let's attach it to our instance. There's only one instance available, so we can see the ID and attach.

So that is now attached to an instance, so we can see it's in use. If we go up to instances, choose our running instance, go to networking, and we can now see that we have multiple interfaces. Select our running instance, go to networking, and we can see it now has multiple network interfaces. So that's how we can work with ENIs.

So we could quite easily now detach that ENI and move it to a different instance.

Now, we only have one instance now, but if you want to play around, launch another nstance, you can detach this interface and then just attach it to another instance as long as that instance is in the same availability zone.

Now, alternatively, create another subnet in the same availability zone and practice moving between different subnets as well.

So you can attach your instance to multiple subnets.

