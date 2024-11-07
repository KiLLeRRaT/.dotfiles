#!/bin/bash
set -e

source install-arch2.variables.sh

echo "DEV_ROOT="$(GET_VAR DEV_ROOT '/dev/$(lsblk --list | fzf --header-lines=1 --prompt="Please select DEV_ROOT: " | cut -d" " -f1)')
echo "LUKS_PASSWORD=$(GET_VAR LUKS_PASSWORD)"

echo Press any key to start partitioning...
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

cryptsetup close root

echo "Done"
