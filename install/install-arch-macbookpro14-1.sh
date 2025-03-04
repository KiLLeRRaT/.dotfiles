#!/bin/bash

set -e

echo Make sure to first run ./install-arch.sh
read -p "Press enter to continue"


sed -i.bak '/^HOOKS=(/c\HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)' /etc/mkinitcpio.conf
sed -i.bak2 '/^MODULES=(/c\MODULES=(intel_lpss_pci btrfs)' /etc/mkinitcpio.conf
sed -i.bak3 '/^BINARIES=(/c\BINARIES=(/usr/bin/btrfs)' /etc/mkinitcpio.conf
mkinitcpio -P

# FROM: https://wiki.archlinux.org/title/Apple_Keyboard#Function_keys_do_not_work
echo 'options applespi fnmode=2 fnremap=1' | sudo tee /etc/modprobe.d/applespi.conf
# MAKE SURE TO HAVE modconf in mkinitcpio.conf HOOKS!
sudo mkinitcpio -P

pushd ~/source-aur
pacman -S gcc linux-headers linux-lts-headers make patch wget
git clone https://github.com/davidjo/snd_hda_macbookpro.git
cd snd_hda_macbookpro/
#run the following command as root or with sudo
sudo ./install.cirrus.driver.sh
echo "You need to reboot after doing the Sound Install. Do you want to reboot? (y/n)"
read reboot
if [ "$reboot" == "y" ]; then
	sudo reboot now
fi
popd

echo "Set up d3cold_allowed service"
sudo cp ~/.dotfiles/hosts/arch-macbookpro13/d3cold_allowed /etc/systemd/system/d3cold_allowed.service

echo "Install Bluetooth patches"
pushd ~/source-aur
git clone https://github.com/leifliddy/macbook12-bluetooth-driver.git
cd macbook12-bluetooth-driver/
# run the following command as root or with sudo
sudo ./install.bluetooth.sh -i
# to uninstall the dkms feature run:
# ./install.bluetooth.sh -u
popd

# echo "Sort out the terminal TTY screen buffer size"
# sudo cp ~/.dotfiles/hosts/arch-agouwsmacbookpro/etc/systemd/system/set-display-resolution.service /etc/systemd/system/set-display-resolution.service
# sudo systemctl enable set-display-resolution.service
# sudo systemctl start set-display-resolution.service

# network not working after suspend, try disabling MAC address randomization
# https://bbs.archlinux.org/viewtopic.php?id=270819
