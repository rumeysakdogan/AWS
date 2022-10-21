# PART 4 - AUTOMOUNT EBS VOLUMES AND PARTITIONS ON REBOOT


# Back up the /etc/fstab file.
sudo cp /etc/fstab /etc/fstab.bak
# Open /etc/fstab file and add the following info to the existing.(UUID's can also be used)
sudo nano /etc/fstab  # sudo vim /etc/fstab   >>> for vim

/dev/xvdf       /mnt/2nd-vol        ext4    defaults,nofail        0       0
/dev/xvdg1      /mnt/3rd-vol-part1   ext4   defaults,nofail        0       0
/dev/xvdg2      /mnt/3rd-vol-part2   ext4   defaults,nofail        0       0

# more info for fstab >> https://wiki.debian.org/fstab
# Reboot and show that configuration exists (NOTE)
sudo reboot now
# List volumes to show current status, all volumes and partittions should be listed
lsblk
# Show the used and available capacities related with volumes and partitions
df -h
# Check if the data still persists.
ls -lh /mnt/2nd-vol/
ls -lh /mnt/3rd-vol-part2/


# NOTE: You can use "sudo mount -a" to mount volumes and partitions after editing fstab file without rebooting.

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
# https://www.tecmint.com/fdisk-commands-to-manage-linux-disk-partitions/

##################-----DON'T FORGET TO TERMINATE YOUR INSTANCES AND DELETE VOLUMES-----####################