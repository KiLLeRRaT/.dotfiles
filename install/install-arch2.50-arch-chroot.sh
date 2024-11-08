#!/bin/bash
set -e

# TODO:
# - [ ] GREETER CUSTOMISATION
# - [ ] YubiKey
# - [ ] Oneshot service to run:
#         betterlockscreen -u ~/.dotfiles/images/
#         ufw rules and enable

source install-arch2.variables.sh

echo "NEW_HOSTNAME=$(GET_VAR NEW_HOSTNAME)"
echo "USERNAME=$(GET_VAR USERNAME)"
echo "CONFIGURE_PACMAN_HOOKS=$(GET_VAR CONFIGURE_PACMAN_HOOKS)"
source ./variables

echo -e "${GREEN}Press any key to start installation...${RESET}"
read -n1

# EXEC AS THE USER WITH OWN ENV VARS
arch-chroot2() {
	arch-chroot -u $USERNAME /mnt /usr/bin/env -i \
		HOME=/home/$USERNAME \
		USER=$USERNAME \
		HOST=$NEW_HOSTNAME \
		$@
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

echo -e "${GREEN}Cloning dotfiles${RESET}"
arch-chroot -u $USERNAME /mnt git clone https://github.com/killerrat/.dotfiles /home/$USERNAME/.dotfiles

echo -e "${GREEN}Generating host config${RESET}"
arch-chroot2 /home/$USERNAME/.dotfiles/nvim-lua/.config/nvim/generateHostConfig.sh

if [ "$CONFIGURE_PACMAN_HOOKS" == "y" ]; then
	echo -e "${GREEN}Configure Pacman Hooks${RESET}"
	mkdir -p /mnt/etc/pacman.d/hooks
	cp /mnt/home/$USERNAME/.dotfiles/pacman/hooks/* /mnt/etc/pacman.d/hooks/
fi

echo -e "${GREEN}Running stow${RESET}"
arch-chroot /mnt /bin/bash -c "cd /home/$USERNAME/.dotfiles/hosts/arch-agouws && stow -t ~ xinitrc"
# arch-chroot /mnt mv /etc/lightdm/lightdm-gtk-greeter.conf{,.bak}
arch-chroot /mnt /bin/bash -c "cd /home/$USERNAME/.dotfiles && stow -t / lightdm"


mkdir -p /mnt/usr/share/backgrounds/$USERNAME
arch-chroot /mnt /bin/bash -c "cd /home/$USERNAME/.dotfiles && stow -t /usr/share/backgrounds/$USERNAME images"
arch-chroot -u $USERNAME /mnt /bin/bash -c "cd /home/$USERNAME/.dotfiles && stow alacritty dmenurc dosbox dunst flameshot fonts gitconfig gtk-2.0 gtk-3.0 gtk-4.0 i3-manjaro nvim-lua oh-my-posh picom ranger tmux zshrc"


echo -e "${GREEN}Let's copy our gtk configs to /root, so that root has the same theme${RESET}"
cp /mnt/home/$USERNAME/.dotfiles/gtk-2.0/.gtkrc-2.0 /mnt/root
mkdir -p /mnt/root/.config
cp -r /mnt/home/$USERNAME/.dotfiles/gtk-3.0/.config/gtk-3.0 /mnt/root/.config
cp -r /mnt/home/$USERNAME/.dotfiles/gtk-4.0/.config/gtk-4.0 /mnt/root/.config




echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Installing AUR Packages${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"

arch-chroot2 mkdir -p /home/$USERNAME/source-aur

installAurPackage oh-my-posh-bin
installAurPackage brave-bin

arch-chroot2 /bin/bash -l -- <<- EOF
	curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
	echo Need to make sure gnome-keyring is correctly setup otherwise 2fa keys wont be remembered.
EOF

installAurPackage 1password


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

arch-chroot /mnt pacman -Sy --noconfirm --needed p7zip
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
ln -s /home/$USERNAME/.dotfiles/scripts/dmenu_recency /mnt/usr/local/bin/dmenu_recency



echo -e "${GREEN}Done${RESET}"
