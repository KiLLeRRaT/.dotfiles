#!/bin/bash
set -e

source install-arch2.variables.sh

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

echo "Activate swapfile"
swapon /mnt/swap/swapfile

echo "Done"
