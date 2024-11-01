#!/bin/bash
set -e

timedatectl set-ntp true
pacman -Sy --noconfirm --needed archlinux-keyring git fzf

if [ -z $DEV_BOOT ] || [ -z $DEV_ROOT ]
then
	DEV_BOOT=/dev/$(lsblk --list | fzf --prompt="Please select DEV_BOOT: " | cut -d' ' -f1)
	echo ""
	DEV_ROOT=/dev/$(lsblk --list | fzf --prompt="Please select DEV_ROOT: " | cut -d' ' -f1)
	echo ""
fi

lsblk
blkid


echo "Enter LUKS password for $DEV_ROOT"
read -s LUKS_PASSWORD

echo DEV_BOOT: $DEV_BOOT
echo DEV_ROOT: $DEV_ROOT
echo LUKS_PASSWORD: $LUKS_PASSWORD

echo Press any key to start installation...
read -n 1


# PARTITION SETUP
echo -n "$LUKS_PASSWORD" | cryptsetup luksOpen $DEV_ROOT root -

mount -o defaults,noatime,ssd,compress=zstd,subvol=@ /dev/mapper/root /mnt
mount -o defaults,noatime,ssd,compress=zstd,subvol=@home /dev/mapper/root /mnt/home
mount -o defaults,noatime,ssd,compress=zstd,subvol=@swap /dev/mapper/root /mnt/swap
mount -o defaults,noatime,ssd,compress=zstd,subvol=@pkg /dev/mapper/root /mnt/var/cache/pacman/pkg
mount -o defaults,noatime,ssd,compress=zstd,subvol=@log /dev/mapper/root /mnt/var/log
mount -o defaults,noatime,ssd,compress=zstd,subvol=@docker /dev/mapper/root /mnt/var/lib/docker
mount -o defaults,noatime,ssd,compress=zstd,subvol=@libvirt /dev/mapper/root /mnt/var/lib/libvirt
mount $DEV_BOOT /mnt/efi

echo "Create and activate swapfile"
btrfs filesystem mkswapfile --size 4g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile

