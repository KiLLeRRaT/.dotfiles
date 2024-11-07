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

# EXEC AS THE USER WITH OWN ENV VARS
arch-chroot2() {
	arch-chroot -u $USERNAME /mnt /usr/bin/env -i HOME=/home/$USERNAME USER=$USERNAME $@
}

installAurPackage() {
	arch-chroot2 /bin/bash -l -- <<- EOF
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


arch-chroot2 mkdir -p /home/$USERNAME/source-aur

exit
installAurPackage oh-my-posh-bin
installAurPackage brave-bin

arch-chroot2 /bin/bash -l -- <<- EOF
	curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
	echo Need to make sure gnome-keyring is correctly setup otherwise 2fa keys wont be remembered.
EOF

installAurPackage 1password

exit

cp /mnt/etc/pam.d/login /mnt/etc/pam.d/login.bak
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


cp /mnt/usr/lib/pam.d/polkit-1 /mnt/etc/pam.d/polkit-1

installAurPackage otf-san-francisco

arch-chroot /mnt pacman -Sy --no-confirm --needed p7zip
installAurPackage otf-san-francisco-mono

installAurPackage pa-applet-git
installAurPackage dracula-gtk-theme
installAurPackage dracula-icons-git

arch-chroot /mnt pacman -Sy --noconfirm --needed python-dbus python-setuptools gtksourceview3
installAurPackage snapper-gui-git

# PROBLEMS WITH DOTNET OR SOMETHING, MAYBE JUST CHROOT RELATED??? LEAVE FOR NOW
# arch-chroot /mnt pacman -Sy --noconfirm --needed cmake clang
# installAurPackage netcoredbg

installAurPackage nvm

arch-chroot /mnt pacman -Sy --noconfirm --needed libkeybinder3 python-setproctitle python-pipenv
installAurPackage emote # Emoji picker, launch with Ctrl + Alt + E

arch-chroot /mnt pacman -R --noconfirm i3lock

arch-chroot /mnt pacman -Sy --noconfirm --needed xcb-util-xrm
installAurPackage i3lock-color
arch-chroot /mnt pacman -Sy --noconfirm --needed imagemagick i3-wm
installAurPackage i3exit
installAurPackage betterlockscreen

arch-chroot2 /bin/bash -l -- <<- EOF
	betterlockscreen -u ~/.dotfiles/images
EOF

# TODO: VERIFY THAT THIS WORKED, CANT IN THE CHROOT RIGHT NOW...
arch-chroot /mnt systemctl enable betterlockscreen@$USERNAME
# lock on sleep/suspend


arch-chroot2 /bin/bash -l -- <<- EOF
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
	cat << EOF > /mnt/etc/X11/xorg.conf.d/90-touchpad.conf
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
