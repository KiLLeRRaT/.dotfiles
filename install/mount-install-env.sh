#!/bin/bash
set -e

timedatectl set-ntp true
sed -i 's/^#Color/Color/g' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/g' /etc/pacman.conf
pacman -Sy --noconfirm --needed archlinux-keyring git fzf

if [ -z $DEV_BOOT ] || [ -z $DEV_ROOT ]
then
	DEV_BOOT=/dev/$(lsblk --list | fzf --prompt="Please select DEV_BOOT: " | cut -d' ' -f1)
	echo ""
	DEV_ROOT=/dev/$(lsblk --list | fzf --prompt="Please select DEV_ROOT: " | cut -d' ' -f1)
	echo ""
fi

echo "DEV_BOOT: $DEV_BOOT"
echo "DEV_ROOT: $DEV_ROOT"
echo "DEV_BOOT_MOUNTPOINT: $DEV_BOOT_MOUNTPOINT"
echo Press any key to continue...
read -n 1

cryptsetup open $DEV_ROOT root

mount -o defaults,noatime,ssd,compress=zstd,subvol=@ /dev/mapper/root /mnt
mount -o defaults,noatime,ssd,compress=zstd,subvol=@home /dev/mapper/root /mnt/home
mount -o defaults,noatime,ssd,compress=zstd,subvol=@swap /dev/mapper/root /mnt/swap
mount -o defaults,noatime,ssd,compress=zstd,subvol=@pkg /dev/mapper/root /mnt/var/cache/pacman/pkg
mount -o defaults,noatime,ssd,compress=zstd,subvol=@log /dev/mapper/root /mnt/var/log
mount -o defaults,noatime,ssd,compress=zstd,subvol=@docker /dev/mapper/root /mnt/var/lib/docker
mount -o defaults,noatime,ssd,compress=zstd,subvol=@libvirt /dev/mapper/root /mnt/var/lib/libvirt

if [ -z $DEV_BOOT_MOUNTPOINT ]
then
	DEV_BOOT_MOUNTPOINT=$(fzf --walker=dir --walker-root=/mnt --prompt="Please select DEV_BOOT_MOUNTPOINT: ")
	echo ""
fi

mount $DEV_BOOT /mnt/efi

swapon /mnt/swap/swapfile
