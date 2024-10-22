#!/bin/bash

# Exit when any command fails
set -e

username=albert
password=""
read -s -p "Enter sudo password: " password
echo -e "$password" | sudo -k -S -p "" echo "Thanks!"
echo -e "$password" | sudo -v -S

# TODO:
# - [ ] systemd services int installer script??
# - [ ] /etc/fonts/local.conf in installer script
# - [ ] btrfs subvolumes for /var/lib/libvirt, and /var/lib/docker, and /mnt/data-temp
# - [ ] Configure /boot to be on the main btrfs / subvolume


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing Arch Linux\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

echo "Configuring pacman"
echo -e "$password" | sudo -v -S
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

echo "Installing more packages"
echo -e "$password" | sudo -v -S
sudo pacman --noconfirm --needed -Syu\
	alacritty \
	aspnet-runtime \
	base-devel \
	bat \
	bc \
	bluez bluez-utils blueman \
	btop \
	btrfs-progs \
	curl \
	dmenu \
	docker docker-compose docker-scan docker-buildx \
	dosbox \
	dotnet-runtime \
	dotnet-sdk \
	dunst \
	fd \
	feh \
	flameshot xdotool \
	fzf \
	git \
	gnome-keyring seahorse lxsession-gtk3 \
	grub-btrfs \
	iotop \
	inotify-tools \
	jq \
	less \
	man \
	mono \
	mono-msbuild \
	ncdu \
	neovim \
	network-manager-applet \
	networkmanager \
	networkmanager-l2tp strongswan \
	nginx \
	noto-fonts-emoji \
	nuget \
	numlockx \
	openfortivpn \
	openssh \
	pacman-contrib \
	pam-u2f \
	pcmanfm \
	picom \
	polkit \
	ranger ueberzug \
	redshift \
	remmina freerdp libvncserver \
	ripgrep \
	rsync \
	signal-desktop discord \
	silicon \
	snap-pac \
	snapper \
	spotify-launcher \
	sshfs \
	stow \
	timeshift \
	tmux \
	tokei \
	tree \
	ttf-cascadia-code-nerd \
	ufw \
	unzip \
	wget \
	wireplumber pipewire-pulse pavucontrol playerctl \
	xautolock \
	xclip \
	xorg-xrandr \
	zathura zathura-pdf-poppler \
	zip \
	zoxide \
	zsh
	# wireplumber pipewire-pulse pulseaudio pavucontrol playerctl

echo "Configuring makepkg"
echo -e "$password" | sudo -v -S
sudo sed -i 's/^PKGEXT.*/PKGEXT=".pkg.tar"/' /etc/makepkg.conf
sudo sed -i 's/\(OPTIONS=.*\)debug/\1!debug/' /etc/makepkg.conf

echo "Hardening /tmp and /dev/shm by setting noexec"
echo -e "$password" | sudo -v -S
tmp=$(findmnt /tmp --output SOURCE,FSTYPE,OPTIONS | tail -n1)
devshm=$(findmnt /dev/shm --output SOURCE,FSTYPE,OPTIONS | tail -n1)
sudo bash -c "cat >> /etc/fstab" << EOF
$(echo $tmp | sed "s/^tmpfs/tmpfs    \/tmp/"),noexec 0 0
$(echo $devshm | sed "s/^tmpfs/tmpfs    \/dev\/shm/"),noexec 0 0
EOF

echo "Starting sshd"
echo -e "$password" | sudo -v -S
sudo systemctl start sshd
sudo systemctl enable sshd

echo "Starting cronie, so that timeshift scheduled snapshots work"
echo -e "$password" | sudo -v -S
sudo systemctl enable cronie.service
sudo systemctl start cronie.service

echo "Starting Bluetooth"
echo -e "$password" | sudo -v -S
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

echo "Starting NetworkManager"
echo -e "$password" | sudo -v -S
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

echo "Starting paccache timer (cleanup unused pacman packages)"
echo -e "$password" | sudo -v -S
sudo systemctl enable paccache.timer
sudo systemctl start paccache.timer

echo "Starting snapper-timeline.timer"
echo -e "$password" | sudo -v -S
sudo systemctl enable snapper-timeline.timer
sudo systemctl start snapper-timeline.timer

echo "Starting snapper-cleanup.timer"
echo -e "$password" | sudo -v -S
sudo systemctl enable snapper-cleanup.timer
sudo systemctl start snapper-cleanup.timer

echo "Starting snapper-boot.timer"
echo -e "$password" | sudo -v -S
sudo systemctl enable snapper-boot.timer
sudo systemctl start snapper-boot.timer

echo "Configuring ufw rules"
echo -e "$password" | sudo -v -S
sudo ufw allow from 192.168.111.0/24 to any app SSH
sudo ufw allow from 192.168.114.0/24 to any app SSH
echo "Enable ufw? (y/n)"
read enable_ufw
if [ "$enable_ufw" == "y" ]; then
	sudo ufw enable
fi

# FROM: https://wiki.archlinux.org/title/Sysctl#Configuration
echo "Enable SysRq"
echo -e "$password" | sudo -v -S
echo "kernel.sysrq=1" | sudo tee /etc/sysctl.d/99-sysctl.conf


echo "Clone dotfiles? (y/n)"
read clone_dotfiles
if [ "$clone_dotfiles" == "y" ]; then
	echo -e "$password" | sudo -v -S
	pushd /home/$username
	if [ -d .dotfiles ]; then
		pushd .dotfiles
		git pull
		popd
	else
		git clone https://github.com/killerrat/.dotfiles
	fi
		popd
fi


echo "Generate host specific configs"
~/.dotfiles/nvim-lua/.config/nvim/generateHostConfig.sh

echo "Running stow"
pushd ~/.dotfiles/hosts/arch-agouws
stow -t ~ xinitrc
popd

pushd ~/.dotfiles
echo "Stow lightdm config"
echo -e "$password" | sudo -v -S
sudo mv /etc/lightdm/lightdm-gtk-greeter.conf{,.bak}
sudo stow -t / lightdm

echo "Stow images into /usr/share/pixmaps"
echo -e "$password" | sudo -v -S
sudo mkdir -p /usr/share/backgrounds/albert
sudo chmod o+x /usr/share/backgrounds/albert
sudo stow -t /usr/share/backgrounds/albert images
sudo chmod o+r /usr/share/backgrounds/albert/*

stow alacritty dmenurc dosbox dunst flameshot fonts gitconfig gtk-2.0 gtk-3.0 gtk-4.0 i3-manjaro nvim-lua oh-my-posh picom ranger tmux zshrc
popd

echo "Configure bat and silicon themes"
mkdir -p "$(bat --config-dir)/themes"
mkdir -p "$(bat --config-dir)/syntaxes"
ln -s ~/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_day.tmTheme ~/.config/bat/themes/tokyonight_day.tmTheme
ln -s ~/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_night.tmTheme ~/.config/bat/themes/tokyonight_night.tmTheme
ln -s ~/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_moon.tmTheme ~/.config/bat/themes/tokyonight_moon.tmTheme
ln -s ~/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_storm.tmTheme ~/.config/bat/themes/tokyonight_storm.tmTheme
bat cache --build
silicon --build-cache


echo "Let's copy our gtk configs to /root, so that root has the same theme"
echo -e "$password" | sudo -v -S
sudo cp /home/albert/.dotfiles/gtk-2.0/.gtkrc-2.0 /root
sudo mkdir -p /root/.config
sudo cp -r /home/albert/.dotfiles/gtk-3.0/.config/gtk-3.0 /root/.config
sudo cp -r /home/albert/.dotfiles/gtk-4.0/.config/gtk-4.0 /root/.config

echo -e "$password" | sudo -v -S
sudo chsh -s /bin/zsh albert

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing AUR Packages\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

[ ! -d ~/source-aur ] && mkdir ~/source-aur

source ./scripts/functions/aur-helpers.sh

installAurPackage oh-my-posh-bin
installAurPackage brave-bin

# BEGIN 1Password config
echo "Set up seahorse and create a default keyring. This is needed for 1Password otherwise it keeps asking the 2FA prompt again and again."
# FROM: https://1password.community/discussion/127523/1password-and-gnome-keyring-for-2fa-saving-on-archlinux
# seahorse

# The below is disabled because it creates `default` but the appls actually now use `default
# keyring` that's created by default so we probably don't need this anymore
# FROM: https://serverfault.com/a/1128330
# [ ! -d ~/.local/share/keyrings ] && mkdir -p ~/.local/share/keyrings/
# if [ ! -f ~/.local/share/keyrings/default.keyring ]
# then
# 	echo -n "Default_keyring" > ~/.local/share/keyrings/default
# 	cat > ~/.local/share/keyrings/default.keyring << EOF
# [keyring]
# display-name=default
# ctime=0
# mtime=0
# lock-on-idle=false
# lock-after=false
# EOF
# 	chmod og= ~/.local/share/keyrings/
# 	chmod og= ~/.local/share/keyrings/default.keyring
# # chown -R $username:$username ~/.local
# fi

curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
installAurPackage 1password
echo Need to make sure gnome-keyring is correctly setup otherwise 2fa keys wont be remembered.

cp /etc/pam.d/login /tmp/login.tmp
echo -e "$password" | sudo -v -S
if [ ! -f /tmp/login.tmp ] # Don't run it again if we have the login.tmp file already
then
	sudo bash -c "cat > /etc/pam.d/login" << 'EOF'
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

# # doesn't yet work
# sudo tac /etc/pam.d/login | sed '0,/session/s/session/session    optional     pam_gnome_keyring.so auto_start\n&/' | tac >> /etc/pam.d/login

fi

# read -p "Let's verify the changes. Press enter to continue"
# echo -e "$password" | sudo -v -S
# sudo nvim -d /etc/pam.d/login /tmp/login.tmp

# Configure polkit-1 for 1Password (Allows using system authentication with 1Password)
sudo cp /usr/lib/pam.d/polkit-1 /etc/pam.d/polkit-1
# lxpolkit will be started as part of my i3 config
# END 1Password config

installAurPackage otf-san-francisco
installAurPackage otf-san-francisco-mono
installAurPackage pa-applet-git
installAurPackage dracula-gtk-theme
installAurPackage dracula-icons-git
installAurPackage snapper-gui-git

#installAurPackage azuredatastudio-bin
#installAurPackage powershell-bin
installAurPackage netcoredbg

sudo pacman -R --noconfirm i3lock
installAurPackage i3lock-color
installAurPackage i3exit

installAurPackage betterlockscreen
betterlockscreen -u ~/.dotfiles/images
# lock on sleep/suspend
echo -e "$password" | sudo -v -S
sudo systemctl enable betterlockscreen@$USER

# installAurPackage forticlient-vpn, in ~/vpn.sh we are using openfortivpn
# sudo pacman -S networkmanager-fortisslvpn

#installAurPackage openfortivpn, it's now in exta, so no need for AUR package anymore
# ALSO NEED TO RUN THE FOLLOWING FOR THE NETWORKING TO WORK CORRECTLY FOR THE VPN:
echo -e "$password" | sudo -v -S
sudo systemctl enable systemd-resolved.service
sudo systemctl start systemd-resolved.service

#installAurPackage icaclient #Citrix workspace app/Citrix receiver
#echo -e "$password" | sudo -v -S
#sudo pacman --noconfirm --needed -Syu perl-file-mimeinfo # Required to interpret the *.ica files correctly
# COPYING AND PASTING NOT WORKING IN icaclient, DISABLE KLIPPER OR CLIPBOARD MANAGER!

installAurPackage nvm
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts

installAurPackage emote # Emoji picker, launch with Ctrl + Alt + E

echo Configure dmenu
echo -e "$password" | sudo -v -S
sudo ln -s ~/.dotfiles/scripts/dmenu_recency /usr/local/bin/dmenu_recency

echo "Enable and start Docker? (y/n)"
read enable_docker
if [ "$enable_docker" == "y" ]; then
	echo -e "$password" | sudo -v -S
	sudo systemctl enable docker
	sudo systemctl start docker
fi

echo "Configure Yubikey? (y/n)"
read configure_yubikey
if [ "$configure_yubikey" == "y" ]; then
	echo -e "$password" | sudo -v -S

	# ykfde
	# SEE: https://wiki.archlinux.org/title/YubiKey#Challenge-response_2

	echo "Configuring pam-u2f"
	mkdir ~/.config/Yubico
	pamu2fcfg --no-user-presence --pin-verification -o pam://$HOST -i pam://$HOST > ~/.config/Yubico/u2f_keys

	echo "pam config"
	authValue="auth sufficient pam_u2f.so cue origin=pam://$HOST appid=pam://$HOST"
	sudo sed -i "2i$authValue" /etc/pam.d/sudo
	sudo sed -i "2i$authValue" /etc/pam.d/system-local-login
	sudo sed -i "2i$authValue" /etc/pam.d/lightdm
	sudo sed -i "2i$authValue" /etc/pam.d/polkit-1
fi

mkdir -p ~/Pictures/screenshots


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure Xorg\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
echo "Configure tap to click on touchpad? (y/n)"
read configure_xorg_taptoclick
if [ "$configure_xorg_taptoclick" == "y" ]; then
	# FROM: https://cravencode.com/post/essentials/enable-tap-to-click-in-i3wm/
	sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
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


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure Pacman Hooks\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
echo "Configure pacman hooks? (y/n)"
read configure_pacman_hooks
if [ "$configure_pacman_hooks" == "y" ]; then
	echo -e "$password" | sudo -v -S
	sudo mkdir -p /etc/pacman.d/hooks
	sudo cp ~/.dotfiles/pacman/hooks/* /etc/pacman.d/hooks/
fi

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure QEMU\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
echo "Configure QEMU and libvirt? (y/n)"
read configure_qemu
if [ "$configure_qemu" == "y" ]; then
	echo -e "$password" | sudo -v -S
	sudo pacman --noconfirm --needed -Syu\
		virt-manager libvirt qemu virt-viewer swtpm

	echo "chattr +C /var/lib/libvirt/? (y/n)"
	read chattr_libvirt
	if [ "$chattr_libvirt" == "y" ]; then
		sudo chattr +C /var/lib/libvirt
	fi
fi





