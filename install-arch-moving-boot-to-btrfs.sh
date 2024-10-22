#!/bin/bash
set -e

# Ideas from: https://github.com/Szwendacz99/Arch-install-encrypted-btrfs
# This script is for moving the boot partition to a btrfs partition

cryptsetup luksOpen /dev/sda2 luks
mount -o subvol=@ /dev/mapper/luks /mnt

mkdir /mnt/boot-old
mount /dev/sda1 /mnt/boot-old
cp -a /mnt/boot-old/* /mnt/boot
rm -rf /mnt/boot/EFI

umount /mnt/boot-old
rmdir /mnt/boot-old


mount /dev/sda1 /mnt/boot/EFI
mkdir /mnt/boot/EFI/boot-bak
mv /mnt/boot/EFI/* /mnt/boot/EFI/boot-bak
# expect error trying to move directory to itself, that's okay

cp -a /mnt/boot/EFI/boot-bak/EFI/* /mnt/boot/EFI

genfstab -U /mnt
# grab the new entry for /boot/EFI and add it to /mnt/etc/fstab


arch-chroot /mnt

vim /etc/mkinitcpio.conf
# add 'btrfs' to the HOOKS array
# e.g. 
# HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt btrfs filesystems fsck)

mkinitcpio -P

vim /etc/default/grub
# GRUB_ENABLE_CRYPTODISK=y

grub-mkconfig -o /boot/grub/grub.cfg
