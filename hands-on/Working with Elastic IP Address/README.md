Working with EC2 IP addresses:

So let's head over to the console. Back in the console,

we have our running instance from before. And you remember, this one has multiple network adapters attached.So we can say we have two network interfaces.

What I'm going to do now is go to network interfaces, select the eth1 adapter, and I'm just goin to detach it, and click on detach.

So I want to show you some behavior and I want to show you how things work without this attached first.

So, we should be able to refresh this and find that it's gone from in-use to available. So let's come back to EC2.

We're going to click on refresh again,select our instance,
and now we only have the one network interface.

Note down your IP addresses.

private IP: 10.0.1.177 
public IP:  3.84.213.18.

Now stop my instance.

And what I want to show you is that we still have the private IP address, but the public IP address is no longer there.

Public IP addresses are dynamic and they get lost when you stop your instance.

Start instance again. Now it has a different public IP address. So it's picked up a new IP address.

Now, the reason I detach the network interface is if you have multiple ENIs attached and you stop and start your instance, then you'll find you don't pick up a public IP.

But you can have a public IP as a static IP assigned to your Elastic Network Interface.

The next thing I wanted to show you is the behavior when you actually reboot your instance instead of stopping it and starting it.

Note down your IP addresses.

private IP: 10.0.1.177 
public IP:  3.84.187.37 

Now reboot instance:

And what we should find is that it comes back up again and it's still got the same address.So when you stop your instance, you lose the address.

But when you restart your instance, you retain the address. And that applies to public IP addresses only, elastic IPs remember they aren't static, they don't change, and private IPs are also static, they don't change either.

So my instance has rebooted and we can see it still has this address.

What I'm going to do now is go down to elastic IPs. And we don't have any elastic IPs in this region at this stage.

Now, note that it uses region terminology here, which means the elastic types are available within a region once you do allocate them.

I'm going to allocate an elastic IP.

And again, it chooses a network border group.

We don't need to specify anything there.

It's going to use Amazon's pool of IPv4 addresses, and then we just choose allocate.So we now have an address.

This is allocated to our account, but not used.

So remember, that means you're going to pay for it because it's not in a use state. So what we need to do now is actually assign this to our Elastic Network Interface.

So what we can do is associate the elastic IP address, choose either instance or network interface.

I'm going to choose network interface. And then I'm going to click on this option. And it doesn't actually

show me the name of the interface here. So I've actually got to find out what that is. So what I'm going to do is open EC2 in a separate window.

And then I'm going to come down, go to network interfaces, select the network interface, and then copy the interface ID.

And let's just note what that is. It ends in 8F5.

So we might just be able to come back and let's just choose that option. And it's the first option in the list here. And then we need to associate it with a private IP address.

And if you just click in the box there, it will bring up the private IP for that interface.

You can also choose whether this IP address is allowed to be reassociated. So we might want to reassociate it.

So let's choose that option and then click on associate.

So now, the elastic IP is associated to the Elastic Network Interface.

So if you go down to network interfaces, and let's just give it a refresh as well to make sure that we can see what we need to see. And then come down and sure enough, we have a public IP. And we can see that it's an elastic IP address.

Great.

So we have that. What I want to do now is associate it back to my instance.So let's choose our instance and then click on attach.


Choose my instance, and under networking, we should find we have the interface eth1 and it has a public IP.

Now, the key difference now is if I stop this instance and then started again, what we should find is we're going to lose the public IP associated with eth0 interface.

But because we have an elastic interface on eth1, that interface should still have an IP address.

So let's stop this instance. It shouldn't take a minute now, and then we're going to reboot it again as soon as it stopped.

So my instance stopped successfully. I started it again and under networking, I can see that we've lost the public IP associated with eth0,

but under network interfaces, we still have the public IP associated with eth1.

And that's because that's an elastic IP,so it's static.

So what if we now launch a new instance?

So I'm going to clear these boxes.Let's launch a new EC2 instance.

And we're going to put it into a different availability zone.

So let's choose the same settings for the instance type and the AMI. Choose the same VPC, but we're going to choose the public-1B subnet instead.Click on next. Click through.

We don't need to change anything else.

Choose web access and we'll launch this instance.

So what I want to do now is see if I can reassociate the elastic IP with a different instance.

So maybe my existing instance fails for some reason.So let's terminate this instance.So that one has failed.

And what we need to do is we've got traffic that's going to the elastic IP address.

So we want to be able to reassociate that elastic IP address to another instance.

And in this case, I want to do it into a different availability zone.

So let's have a look. We've now got our second instance running.

So what we can do is we can't reassociate the network adapter remember, because it's actually within the wrong availability zone.

It's in the public-1A availability zone. But the elastic IP can be reassociated.

So let's choose actions, disassociate address, and we have to select the address pair combination here and disassociate.

And that should now release our elastic IP address.

So let's come down to elastic IPs.We can see we have an elastic IP address still, and it's not associated.

So what we can do now is go to actions, associate elastic IP address.

We're going to choose instance, and we only have one running instance because we terminated our other instance.

And then we're going to assign it to the instance and click on associate.

Now I didn't specify the private IP, but it only has one, so it's automatically taken care of that for me.

So now if we go back up to instances, we've got this new instance that's still initializing and it should now have an elastic IP address.

So let's go to networking, network interfaces, come down and we can see it has an allocated IPv4 address, which is an EIP.

So that's how we can reassociate elastic IPs.

So we can come down to network interfaces.

We can find eth1, choose actions, and delete. And then choose delete.

Then we go to elastic IPs. And if we just refresh just to make sure that this has been disassociated.

Well, it's still terminating.Let's just disassociate this address.

It's now not attached, which means I can release the elastic IP and then I'm not going to pay for it because it's not attached to anything.

