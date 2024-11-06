#!/bin/bash
set -e

GREEN=\033[32m
RESET=${RESET}

source install-arch2.variables.sh

echo Press any key to start installation...
read -n 1

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Installing AUR Packages${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
installAurPackage() {
	arch-chroot -u $USERNAME /mnt /bin/bash -- <<- EOF
		pushd /home/$USERNAME/source-aur
		echo "Installing $1"
		if [ ! -d $1 ]; then
			git clone https://aur.archlinux.org/$1.git
			cd $1
		else
			cd $1
			git pull
		fi
		makepkg
		popd
	EOF
	echo "Done building $1, installing now..."
	arch-chroot /mnt /bin/bash -c "pacman --noconfirm --needed -U /home/$USERNAME/source-aur/$1/*.pkg.*"
}

arch-chroot -u $USERNAME /mnt mkdir -p /home/$USERNAME/source-aur

installAurPackage oh-my-posh-bin

# missing dep, ttf-font
installAurPackage brave-bin

arch-chroot -u $USERNAME /mnt /bin/bash -- <<- EOF

	curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
	echo Need to make sure gnome-keyring is correctly setup otherwise 2fa keys wont be remembered.
EOF

installAurPackage 1password

exit

cp /mnt/etc/pam.d/login /mnt/tmp/login.tmp
if [ ! -f /mnt/tmp/login.tmp ] # Don't run it again if we have the login.tmp file already
then
	cat <<- EOF > /mnt/etc/pam.d/login
		#%PAM-1.0
		auth       required     pam_securetty.so
		auth       requisite    pam_nologin.so
		auth       include      system-local-login
		auth       optional     pam_gnome_keyring.so
		account    include      system-local-login
		session    include      system-local-login
		session    optional     pam_gnome_keyring.so auto_start
		password   include      system-local-login
	EOF
fi


cp /mnt/usr/lib/pam.d/polkit-1 /mnt/etc/pam.d/polkit-1

arch-chroot -u $USERNAME /mnt /bin/bash -- <<- EOF
	source /home/$USERNAME/.dotfiles/scripts/functions/aur-helpers.sh
	installAurPackage otf-san-francisco
	installAurPackage otf-san-francisco-mono
	installAurPackage pa-applet-git
	installAurPackage dracula-gtk-theme
	installAurPackage dracula-icons-git
	installAurPackage snapper-gui-git
	installAurPackage netcoredbg
	installAurPackage nvm
	installAurPackage emote # Emoji picker, launch with Ctrl + Alt + E
EOF

arch-chroot /mnt pacman -R --noconfirm i3lock

arch-chroot -u $USERNAME /mnt /bin/bash -- <<- EOF
	source /home/$USERNAME/.dotfiles/scripts/functions/aur-helpers.sh
	installAurPackage i3lock-color
	installAurPackage i3exit
	installAurPackage betterlockscreen
	betterlockscreen -u ~/.dotfiles/images
EOF

arch-chroot /mnt systemctl enable betterlockscreen@$USERNAME
# lock on sleep/suspend


arch-chroot -u $USERNAME /mnt /bin/bash -- <<- EOF
	source /usr/share/nvm/init-nvm.sh
	nvm install --lts
	nvm use --lts
	mkdir -p /home/$USERNAME/Pictures/screenshots
EOF

# arch-chroot /mnt ln -s /home/$USERNAME/.dotfiles/scripts/dmenu_recency /usr/local/bin/dmenu_recency
ln -s /mnt/home/$USERNAME/.dotfiles/scripts/dmenu_recency /usr/local/bin/dmenu_recency


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Configure Xorg${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
echo "Configure tap to click on touchpad? (y/n)"
read configure_xorg_taptoclick
if [ "$configure_xorg_taptoclick" == "y" ]; then
	# FROM: https://cravencode.com/post/essentials/enable-tap-to-click-in-i3wm/
	mkdir -p /mnt/etc/X11/xorg.conf.d
	cat <<- EOF > /mnt/etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
	Section "InputClass"
		Identifier "touchpad"
		MatchIsTouchpad "on"
		Driver "libinput"
		Option "Tapping" "on"
		Option "TappingButtonMap" "lrm"
		Option "NaturalScrolling" "on"
		Option "ScrollMethod" "twofinger"
	EndSection
	EOF
fi

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Configure Pacman Hooks${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
echo "Configure pacman hooks? (y/n)"
read configure_pacman_hooks
if [ "$configure_pacman_hooks" == "y" ]; then
	mkdir -p /mnt/etc/pacman.d/hooks
	cp /mnt/home/$USERNAME/.dotfiles/pacman/hooks/* /mnt/etc/pacman.d/hooks/
fi

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Configure QEMU${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
echo "Configure QEMU and libvirt? (y/n)"
read configure_qemu
if [ "$configure_qemu" == "y" ]; then
	arch-chroot /mnt pacman --noconfirm --needed -Syu virt-manager libvirt qemu virt-viewer swtpm
fi

# TODO: 
# - [ ] GREETER CUSTOMISATION
# - [ ] YubiKey

echo "Done"
