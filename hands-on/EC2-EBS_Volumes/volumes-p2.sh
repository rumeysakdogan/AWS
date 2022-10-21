# PART 2 - CREATE NEW EBS VOLUME, ATTACH IT AND MODIFY

# Create a new volume "in the SAME AZ with the INSTANCE" (2 GB for this demo).
# Attach the new volume to the instance and then list block storages again.
# Root volume and the newly created second volumes should be listed.
lsblk
df -h # h flag: for humanreadible
# Check if the attached volume is already formatted or not. It should be NOT FORMATTED.
sudo file -s /dev/xvdf
# Format the new volume.
sudo mkfs -t ext4 /dev/xvdf #t flag:type
# Check the format of the volume again after formatting.
sudo file -s /dev/xvdf
# Create a mounting point path for new volume
sudo mkdir /mnt/2nd-vol
# Mount the new volume to the mounting point path.
sudo mount /dev/xvdf /mnt/2nd-vol/
# Check if the attached volume is mounted to the mounting point path.
lsblk
# Show the available space, on the mounting point path.
df -h
# Check if there is data on it or not.
ls -lh /mnt/2nd-vol/
# Create a new file to show persistence in later steps.
cd /mnt/2nd-vol
sudo touch guilewashere.txt
ls
# Modify the new volume in aws console, and enlarge capacity to double its size (2GB >> 4GB).
# Check if the attached volume shows the new capacity.
lsblk
# Show the real capacity used currently at mounting path, old capacity should be displayed.
df -h
# Resize the EXT4 file system on the new volume to cover all available space.
sudo resize2fs /dev/xvdf
# Show the real capacity used currently at mounting path, new capacity should reflect the modified volume size.
df -h
# Show that the data still persists on the newly enlarged volume.
ls -lh /mnt/2nd-vol/
# Show that mounting point path is gone when instance reboots.
sudo reboot now
# Show the new volume is still attached, but not mounted.
lsblk
# Check if the attached volume is formatted or not.
sudo file -s /dev/xvdf
# Mount the new volume to the mounting point path again.
sudo mount /dev/xvdf /mnt/2nd-vol/
# show the used and available capacity is same as the disk size.
lsblk
df -h
# if there is data on it, check if the data still persists.
ls -lh /mnt/2nd-vol/