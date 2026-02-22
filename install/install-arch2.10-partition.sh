#!/bin/bash
set -e

source install-arch2.variables.sh

echo "DEV_ROOT="$(GET_VAR DEV_ROOT '/dev/$(lsblk --list | fzf --header-lines=1 --prompt="Please select DEV_ROOT: " | cut -d" " -f1)')
echo ""
echo "LUKS_PASSWORD=$(GET_VAR LUKS_PASSWORD)"
echo "If you want to unlock using CLEVIS, use encrypted boot, i.e.: 'y'"
echo "ENCRYPTED_BOOT=$(GET_VAR ENCRYPTED_BOOT)"
source ./variables

echo -e "${GREEN}Press any key to start partitioning...${RESET}"
read -n 1

echo -e -e "${GREEN}Creating LUKS and BTRFS filesystems on $DEV_ROOT${RESET}"
echo -n "$LUKS_PASSWORD" | cryptsetup luksFormat --pbkdf pbkdf2 $DEV_ROOT -
echo -n "$LUKS_PASSWORD" | cryptsetup luksOpen $DEV_ROOT root -
mkfs.btrfs --label system /dev/mapper/root
mount /dev/mapper/root /mnt

echo -e -e "${GREEN}Creating subvolumes${RESET}"
btrfs subvol create /mnt/@
btrfs subvol create /mnt/@home
btrfs subvol create /mnt/@swap
btrfs subvol create /mnt/@pkg
btrfs subvol create /mnt/@log
btrfs subvol create /mnt/@docker
btrfs subvol create /mnt/@libvirt

umount -R /mnt
mount -o defaults,noatime,ssd,compress=zstd,subvol=@ /dev/mapper/root /mnt

echo -e -e "${GREEN}Creating directories in ${DEV_ROOT}${RESET}"

if [ "$ENCRYPTED_BOOT" == "y" ]; then
	mkdir -p /mnt/efi
else
	mkdir -p /mnt/boot
fi

mkdir -p /mnt/home
mkdir -p /mnt/swap
mkdir -p /mnt/var/cache/pacman/pkg
mkdir -p /mnt/var/log
mkdir -p /mnt/var/lib/docker
mkdir -p /mnt/var/lib/libvirt

umount -R /mnt

cryptsetup close root

echo -e "${GREEN}Done${RESET}"
