#!/bin/bash
set -e

timedatectl set-ntp true
sed -i 's/^#Color/Color/g' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/g' /etc/pacman.conf
pacman -Sy --noconfirm --needed archlinux-keyring git fzf

# if variables file exists, source it and do not ask for input
VARIABLES_SET=false
if [ -f ~/variables ]
then
	echo "Found variables file:"
	cat ~/variables

	echo "Source it?"
	read source_variables
	if [ "$source_variables" == "y" ]
	then
		source ~/variables
		VARIABLES_SET=true
	fi
fi

if [ "$VARIABLES_SET" == "false" ]
then
	echo "Variables not set, please set them now"
	if [ -z $DEV_BOOT ] || [ -z $DEV_ROOT ]
	then
		DEV_BOOT=/dev/$(lsblk --list | fzf --prompt="Please select DEV_BOOT: " | cut -d' ' -f1)
		echo ""
		DEV_ROOT=/dev/$(lsblk --list | fzf --prompt="Please select DEV_ROOT: " | cut -d' ' -f1)
		echo ""
	fi

	lsblk
	blkid
	DEVICE_UUID=$(blkid | fzf --prompt="Please select the DEV_ROOT device again so we can get the UUID: " | sed -E 's/^.*UUID="(.{36})" .*$/\1/')
	echo ""
	echo "What is your hostname? (e.g. arch-agouwsmacbookpro)"
	read HOSTNAME

	echo "What is your username? (e.g. albert)"
	read USERNAME

	echo "Enter LUKS password for $DEV_ROOT"
	read LUKS_PASSWORD

	echo "Enter root password"
	read ROOT_PASSWORD

	echo "Enter user password"
	read USER_PASSWORD

	# Write to variables file
	echo "DEV_BOOT=\"$DEV_BOOT\"" > ~/variables
	echo "DEV_ROOT=\"$DEV_ROOT\"" >> ~/variables
	echo "HOSTNAME=\"$HOSTNAME\"" >> ~/variables
	echo "USERNAME=\"$USERNAME\"" >> ~/variables
	echo "DEVICE_UUID=\"$DEVICE_UUID\"" >> ~/variables
	echo "LUKS_PASSWORD=\"$LUKS_PASSWORD\"" >> ~/variables
	echo "ROOT_PASSWORD=\"$ROOT_PASSWORD\"" >> ~/variables
	echo "USER_PASSWORD=\"$USER_PASSWORD\"" >> ~/variables
fi

echo DEV_BOOT: $DEV_BOOT
echo DEV_ROOT: $DEV_ROOT
echo HOSTNAME: $HOSTNAME
echo USERNAME: $USERNAME
echo DEVICE_UUID: $DEVICE_UUID
echo LUKS_PASSWORD: $LUKS_PASSWORD
echo ROOT_PASSWORD: $ROOT_PASSWORD
echo USER_PASSWORD: $USER_PASSWORD

echo "Done setting variables"
