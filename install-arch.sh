#!/bin/bash

# Exit when any command fails
set -e

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing Arch Linux\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

echo Setting root password to \"root\"
echo "root" | passwd --stdin # SET A ROOT PASSWORD SO WE CAN SSH IN
timedatectl set-ntp true
pacman -Sy archlinux-keyring

echo "Set up partitions and figure out where you're going to install Arch"
exit 1

# lsblk
# cfdisk /dev/nvme0n1
# # MAKE A PARTITION WITH 128MB BETWEEN APPLE AND LINUX PARTITION
# # SET THE TYPE TO LVM
# cryptsetup luksFormat /dev/nvme0n1p4
# cryptsetup luksOpen /dev/nvme0n1p4 lvm

# pvcreate /dev/mapper/lvm
# vgcreate vgcrypt /dev/mapper/lvm

# lvcreate --size 20G --name swap vgcrypt
# lvcreate --extents +100%FREE --name root vgcrypt

# mkswap -L swap /dev/mapper/vgcrypt-swap
# swapon -L swap

# mkfs.btrfs --label system /dev/mapper/vgcrypt-root
# mount -t btrfs LABEL=system /mnt

# btrfs subvolume create /mnt/@
# btrfs subvolume create /mnt/@home
# btrfs subvolume create /mnt/@snapshots
# umount -R /mnt

# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@ LABEL=system /mnt
# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@home LABEL=system /mnt/home
# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@snapshots LABEL=system /mnt/.snapshots

# mkdir -p /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot


echo "Are you ready to install? Make sure that you have your new partition mounted in /mnt, AND mounted /mnt/boot"
read install_base
if [ "$install_base" == "y" ]; then
	pacstrap -K /mnt base linux linux-firmware neovim
fi


echo "Do you want to generate an fstab? (y/n)"
read generate_fstab
if [ "$generate_fstab" == "y" ]; then
	genfstab -p /mnt >> /mnt/etc/fstab
fi

echo "Do you want to add a swap entry to crypttab? (y/n)"
read add_swap
if [ "$add_swap" == "y" ]; then
	echo "swap /dev/mapper/vgcrypt-swap /dev/urandom swap,offset=2048,cipher=aes-xts-plain64,size=256" >> /mnt/etc/crypttab
fi

echo "Make sure your /mnt/etc/fstab looks something like this with crypt tab mapper"
# # UUID=0cc4f593-dcd5-44a2-b4a4-23458b9e4fc9 LABEL=swap
# /dev/mapper/swap        none            swap            defaults        0 0

echo "Copying this install file into the new system /install-arch.sh"
cp install-arch.sh /mnt/install-arch.sh

echo "Let's jump into the new system"
arch-chroot /mnt

echo "Setting up timezone"
ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime

echo "Set hardware clock"
hwclock --systohc

echo "Set locale"
sed -i 's/#en_NZ.UTF-8 UTF-8/en_NZ.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_NZ.UTF-8" > /etc/locale.conf


echo "Set hostname"
echo "arch-agouwsmacbookpro" > /etc/hostname
echo "127.0.0.1   localhost.localdomain   localhost   arch-agouwsmacbookpro" >> /etc/hosts
echo "::1   localhost.localdomain   localhost   arch-agouwsmacbookpro" >> /etc/hosts

echo "Installing more packages"
pacman -Syu \
networkmanager \
base-devel \
btrfs-progs \
gptfdisk \
neovim \
zsh \
sudo \
sbctl \
polkit \
lvm2 \
dhcpcd \
systemd \
snapper \
snap-pac \
fzf \
ripgrep \
fd \
feh \
network-manager-applet \
tree \
bc \
spotify-launcher \
networkmanager \
base-devel \
btrfs-progs \
gptfdisk \
neovim \
zsh \
sudo \
sbctl \
polkit \
lvm2 \
dhcpcd \
systemd \
openssh \
ranger \
flameshot \
xclip \
gnome-keyring seahorse \
picom \
xorg \
xorg-xinit \
alacritty \
ttf-cascadia-code-nerd \
i3 \
linux-headers \
dmenu \
redshift

