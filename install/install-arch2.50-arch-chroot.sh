#!/bin/bash
set -e

GREEN=\033[32m
RESET=${RESET}

for i in "$@"
do
case $i in
		-c=*|--continue-from-line=*)
		CONTINUE_FROM_LINE="${i#*=}"
		shift # past argument=value
		;;
		-h|--help)
		echo "Usage: install-arch2.sh [OPTION]"
		echo "Options:"
		echo "  -c, --continue-from-line=NUM  Continue from line number NUM"
		echo "  -h, --help                    Display this help message"
		exit 0
		;;
		*)
					# unknown option
		;;
esac
done

if [ ! -z $CONTINUE_FROM_LINE ]
then
	SCRIPT_CONTENTS=$(cat $0 | sed -n "1,/^echo Press any key to start installation.../p;$CONTINUE_FROM_LINE,\$p")
	echo "$SCRIPT_CONTENTS" > install-arch2.sh.continue
	chmod u+x install-arch2.sh.continue
	cat ./install-arch2.sh.continue
	exit 0
fi

echo "What is your hostname? (e.g. arch-agouwsmacbookpro)"
read HOSTNAME

echo "What is your username? (e.g. albert)"
read USERNAME

echo "Enter LUKS password for $DEV_ROOT"
read -s LUKS_PASSWORD

echo "Enter root password"
read -s ROOT_PASSWORD

echo "Enter user password"
read -s USER_PASSWORD

echo DEV_BOOT: $DEV_BOOT
echo DEV_ROOT: $DEV_ROOT
echo HOSTNAME: $HOSTNAME
echo USERNAME: $USERNAME
echo DEVICE_UUID: $DEVICE_UUID
echo LUKS_PASSWORD: $LUKS_PASSWORD
echo ROOT_PASSWORD: $ROOT_PASSWORD
echo USER_PASSWORD: $USER_PASSWORD

echo Press any key to start installation...
read -n 1

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Installing AUR Packages${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"

mkdir -p /mnt/home/$USERNAME/source-aur

arch-chroot -u $USERNAME /mnt /bin/bash -- <<- EOF
	source /home/$USERNAME/.dotfiles/scripts/functions/aur-helpers.sh
	installAurPackage oh-my-posh-bin
	installAurPackage brave-bin

	curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
	installAurPackage 1password
	echo Need to make sure gnome-keyring is correctly setup otherwise 2fa keys wont be remembered.
EOF

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
ln -s /mnt/home/$USERNAME/.dotfiles/scripts/dmenu_recency /mnt/usr/local/bin/dmenu_recency


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
