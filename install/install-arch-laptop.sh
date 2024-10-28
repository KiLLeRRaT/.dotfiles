#!/bin/bash

set -e

echo "Run this after running your normal install-arch.sh, this configures laptop specifics"
echo "Continue? [y/N]"
read -n 1 -r response
if [[ ! "$response" =~ ^([yY])$ ]]; then
		exit 1
fi

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure laptop specifics\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

source ./scripts/functions/aur-helpers.sh
installAurPackage laptop-mode-tools

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure swap and hibernation\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

# FROM: https://wiki.archlinux.org/title/Btrfs#Swap_file
sudo mount /dev/mapper/root /mnt
pushd /mnt
sudo btrfs subvolume create @swap

sudo bash -c "cat > /etc/fstab" << EOF
# /dev/mapper/ainstsda2
UUID=$(sudo blkid -s UUID -o value /dev/mapper/root) /swap btrfs rw,relatime,ssd,space_cache,subvolid=$(sudo btrfs subvolume list /mnt | grep @swap | awk '{print $2}'),subvol=@swap 0 0
EOF

sudo mount -a
sudo btrfs filesystem mkswapfile --size 4g --uuid clear /swap/swapfile
sudo swapon /swap/swapfile

sudo bash -c "cat > /etc/fstab" << EOF
/swap/swapfile none swap defaults 0 0
EOF

popd

# Now with swap enabled, continue the guide here:
# https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation

