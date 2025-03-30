#!/bin/bash
set -e

source install-arch2.variables.sh

echo "DEV_BOOT="$(GET_VAR DEV_BOOT '/dev/$(lsblk --list | fzf --header-lines=1 --prompt="Please select DEV_BOOT: " | cut -d" " -f1)')
echo ""
echo "DEV_ROOT="$(GET_VAR DEV_ROOT '/dev/$(lsblk --list | fzf --header-lines=1 --prompt="Please select DEV_ROOT: " | cut -d" " -f1)')
echo ""
echo "LUKS_PASSWORD=$(GET_VAR LUKS_PASSWORD)"
source ./variables

echo -e "${GREEN}Press any key to mount volumes...${RESET}"
read -n 1


# PARTITION SETUP
echo -n "$LUKS_PASSWORD" | cryptsetup --allow-discards --persistent open $DEV_ROOT root -

echo -e "${GREEN}Mounting volumes${RESET}"
mount -o defaults,noatime,ssd,compress=zstd,subvol=@ /dev/mapper/root /mnt
mount -o defaults,noatime,ssd,compress=zstd,subvol=@home /dev/mapper/root /mnt/home
mount -o defaults,noatime,ssd,compress=zstd,subvol=@swap /dev/mapper/root /mnt/swap
mount -o defaults,noatime,ssd,compress=zstd,subvol=@pkg /dev/mapper/root /mnt/var/cache/pacman/pkg
mount -o defaults,noatime,ssd,compress=zstd,subvol=@log /dev/mapper/root /mnt/var/log
mount -o defaults,noatime,ssd,compress=zstd,subvol=@docker /dev/mapper/root /mnt/var/lib/docker
mount -o defaults,noatime,ssd,compress=zstd,subvol=@libvirt /dev/mapper/root /mnt/var/lib/libvirt
mount $DEV_BOOT /mnt/efi

if [ ! -f /mnt/swap/swapfile ]
then
	echo -e "${GREEN}Creating swapfile${RESET}"
	btrfs filesystem mkswapfile --size 4g --uuid clear /mnt/swap/swapfile
fi

echo -e "${GREEN}Activating swapfile${RESET}"
swapon /mnt/swap/swapfile

echo -e "${GREEN}Done${RESET}"
