#!/bin/bash
set -e

# Ideas from: https://github.com/Szwendacz99/Arch-install-encrypted-btrfs
# This script is for moving the boot partition to a btrfs partition


cryptsetup luksOpen /dev/sda2 luks
mount -o subvol=@ /dev/mapper/luks /mnt
mount /dev/sda1 /mnt/boot

cp -r /mnt/boot /mnt/boot-old
rm -rf /mnt/boot/*
umount /mnt/boot



arch-chroot /mnt

vim /etc/default/grub
# GRUB_ENABLE_CRYPTODISK=y
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB

vim /etc/mkinitcpio.conf
# add 'btrfs' to the HOOKS array
# e.g. 
# HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt btrfs filesystems fsck)

pacman -Sy linux linux-lts intel-ucode
mkinitcpio -P

# https://wiki.archlinux.org/title/GRUB#Installation


# Make sure you're using PBKDF2 for LUKS2
# https://wiki.archlinux.org/title/GRUB#LUKS2
