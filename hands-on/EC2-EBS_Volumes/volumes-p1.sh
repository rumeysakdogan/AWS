# PART 1 - EXTEND ROOT VOLUME

# Launch an Amazon Linux 2 instance with default ebs volume and ssh to it.
# List block devices (lsblk) and file system disk space usage (df) of the instance. 
# Only root volume should be listed with the default capacity.
lsblk
df -h
# Check file system of the root volume's partition.
sudo file -s /dev/xvda1
# Go to Volumes, select instance's root volume and modify it (increase capacity 8 GB >> 12 GB).
# List block devices (lsblk) and file system disk space usage (df) of the instance again.
# Root volume should be listed as increased but partition and file system should be listed same as before.
lsblk
df -h
# Extend partition 1 on the modified volume and occupy all newly avaiable space.
sudo growpart /dev/xvda 1
# Resize the xfs file system on the extended partition to cover all available space.
sudo xfs_growfs /dev/xvda1
# List block devices (lsblk) and file system disk space usage (df) of the instance again.
# Partition and file system should be extended.
lsblk
df -h
