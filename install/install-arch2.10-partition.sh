#!/bin/bash
set -e


source install-arch2.variables.sh

echo Press any key to start installation...
read -n 1

echo -n "$LUKS_PASSWORD" | cryptsetup luksFormat --pbkdf pbkdf2 $DEV_ROOT -
echo -n "$LUKS_PASSWORD" | cryptsetup luksOpen $DEV_ROOT root -
mkfs.btrfs --label system /dev/mapper/root
mount /dev/mapper/root /mnt

btrfs subvol create /mnt/@
btrfs subvol create /mnt/@home
btrfs subvol create /mnt/@swap
btrfs subvol create /mnt/@pkg
btrfs subvol create /mnt/@log
btrfs subvol create /mnt/@docker
btrfs subvol create /mnt/@libvirt

umount -R /mnt
mount -o defaults,noatime,ssd,compress=zstd,subvol=@ /dev/mapper/root /mnt

mkdir -p /mnt/efi
mkdir -p /mnt/home
mkdir -p /mnt/swap
mkdir -p /mnt/var/cache/pacman/pkg
mkdir -p /mnt/var/log
mkdir -p /mnt/var/lib/docker
mkdir -p /mnt/var/lib/libvirt

umount -R /mnt

# after partitioning, we need to update the variables file with the new DEVICE_UUID
DEVICE_UUID=$(blkid | fzf --prompt="Please select the DEV_ROOT device for cryptsetup: " | sed -E 's/^.*UUID="(.{36})" .*$/\1/')
sed -i '/^DEVICE_UUID=/d' ~/variables
echo "DEVICE_UUID=\"$DEVICE_UUID\"" >> ~/variables

cryptsetup close root

echo "Done"
