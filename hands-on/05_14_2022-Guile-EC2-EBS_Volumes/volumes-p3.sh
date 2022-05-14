# PART 3 - CREATE NEW EBS VOLUME (AND PARTITION), ATTACH IT AND MODIFY

# List volumes to show current status, Root and second volumes should be listed.
lsblk
# Show the used and available capacities related with volumes.
df -h
# Create third volume (4 GB for this demo) in the same AZ with the instance.
# Attach the new volume and list volumes again.
# Root, second and third volumes should be listed.
lsblk
# Show the used and available capacities related with volumes.
df -h
# Show the current partitions ("fdisk -l /dev/xvda" for specific partition).
sudo fdisk -l
# Check all available fdisk commands and using "m".
sudo fdisk /dev/xvdg
# n -> add new partition (with 2G size)
# p -> primary
# Partition number: 1
# First sector: default - use Enter to select default
# Last sector: +2g   (you can also type sector)
# n -> add new partition (with rest of the size-2G)
# p -> primary
# Partition number: 2
# First sector: default - use Enter to select default
# Last sector: default - use Enter to select default
# w -> write partition table
# Show new partitions
lsblk
# Check if the newly created partitons are formatted or not. They should be NOT FORMATTED.
sudo file -s /dev/xvdg1
sudo file -s /dev/xvdg2
# Format the new partitions.
sudo mkfs -t ext4 /dev/xvdg1
sudo mkfs -t ext4 /dev/xvdg2
# Create mounting point paths for the new volume.
sudo mkdir /mnt/3rd-vol-part1
sudo mkdir /mnt/3rd-vol-part2
# Mount the partitions to the mounting point paths.
sudo mount /dev/xvdg1 /mnt/3rd-vol-part1/
sudo mount /dev/xvdg2 /mnt/3rd-vol-part2/
# List volumes to show current status, all volumes and partittions should be listed.
lsblk
# Show the used and available capacities related with volumes and partitions.
df -h
# Create a new file to show persistence in later steps.
sudo touch /mnt/3rd-vol-part2/guilewashere2.txt
ls -lh /mnt/3rd-vol-part2/
# Modify the new (3rd) volume, and enlarge capacity to double its size (4GB >> 8GB).
# Check if the attached volume is showing the new capacity.
lsblk
# Show the real capacity used currently at mounting path, old capacity should be shown.
df -h
# Extend the partition 2 and occupy all newly avaiable space.
sudo growpart /dev/xvdg 2
# ​Show the real capacity used currently at mounting path, updated capacity should be shown.
lsblk
# Resize and extend the file system.
sudo resize2fs /dev/xvdg2
# show the newly created file to show persistence
ls -lh /mnt/3rd-vol-part2/
# reboot and show that configuration is gone
sudo reboot now
#############################
