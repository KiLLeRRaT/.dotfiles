#!/bin/bash

# Exit when any command fails
set -e

username=albert
password=""
read -s -p "Enter sudo password: " password
echo -e "$password" | sudo -k -S -p "" echo "Thanks!"
echo -e "$password" | sudo -v -S

# TODO:
# - [ ] Bridge br0
# - [ ] VMs
# - [ ] forticlient-vpn
# - [ ] Firewall
# - [ ] Sourcecode backups
# - [ ] Machine backups
# - [ ] nginx
# - [ ] @libvirt on data disk mount and move VMs
# - [ ] unlock /mnt/data automatically
# - [ ] ssh unlock luks

# - [ ] Pacman hooks into installer script
# - [ ] systemd services int installer script??
# - [ ] /etc/fonts/local.conf in installer script
# - [ ] /etc/X11/xorg.conf.d/ into installer script
# - [ ] firewall rules into installer script


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing Arch Linux\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

echo "Installing more packages"
echo -e "$password" | sudo -v -S
sudo pacman --noconfirm --needed -Syu\
	alacritty \
	aspnet-runtime \
	base-devel \
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
	gnome-keyring seahorse \
	less \
	mono \
	mono-msbuild \
	neovim \
	network-manager-applet \
	networkmanager \
	nginx \
	nuget \
	openssh \
	pcmanfm \
	picom \
	polkit \
	ranger ueberzug \
	redshift \
	remmina freerdp libvncserver \
	ripgrep \
	rsync \
	snap-pac \
	snapper \
	spotify-launcher \
	stow \
	timeshift \
	tmux \
	tree \
	ttf-cascadia-code-nerd \
	unzip \
	wget \
	xautolock \
	xclip \
	zip \
	zoxide \
	zsh \
	networkmanager-l2tp strongswan \
	numlockx \
	jq \
	iotop \
	xorg-xrandr \
	virt-manager libvirt qemu virt-viewer swtpm \
	zathura zathura-pdf-poppler \
	sshfs \
	signal-desktop discord \
	wireplumber pipewire-pulse pavucontrol playerctl
	# wireplumber pipewire-pulse pulseaudio pavucontrol playerctl

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


# FROM: https://wiki.archlinux.org/title/Sysctl#Configuration
echo "Enable SysRq"
echo -e "$password" | sudo -v -S
echo "1" | sudo tee /proc/sys/kernel/sysrq


# echo "Cloning dotfiles"
# pushd /home/$username
# git clone https://github.com/killerrat/.dotfiles
# popd

echo "Generate host specific configs"
~/.dotfiles/nvim-lua/.config/nvim/generateHostConfig.sh

echo "Running stow"
pushd ~/.dotfiles/hosts/arch-agouws
stow -t ~ xinitrc
popd

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

pushd ~/.dotfiles
stow alacritty dmenurc dosbox dunst fonts gitconfig gtk-2.0 gtk-3.0 gtk-4.0 i3-manjaro nvim-lua oh-my-posh picom ranger tmux zshrc
popd

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

installAurPackage() {
	pushd ~/source-aur
	echo "Installing $1"
	if [ ! -d $1 ]; then
		git clone https://aur.archlinux.org/$1.git
		cd $1
	else
		cd $1
		git pull
	fi
	makepkg --noconfirm -is --needed
	popd
}

echo -e "$password" | sudo -v -S
installAurPackage oh-my-posh-bin
echo -e "$password" | sudo -v -S
installAurPackage brave-bin

echo "Set up seahorse and create a default keyring. This is needed for 1Password otherwise it keeps asking the 2FA prompt again and again."
# FROM: https://1password.community/discussion/127523/1password-and-gnome-keyring-for-2fa-saving-on-archlinux
seahorse


curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
echo -e "$password" | sudo -v -S
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
fi

read -p "Let's verify the changes. Press enter to continue"
echo -e "$password" | sudo -v -S
sudo nvim -d /etc/pam.d/login /tmp/login.tmp


installAurPackage otf-san-francisco
installAurPackage otf-san-francisco-mono
installAurPackage pa-applet-git
installAurPackage dracula-gtk-theme
installAurPackage dracula-icons-git
installAurPackage snapper-gui-git

echo -e "$password" | sudo -v -S
installAurPackage azuredatastudio-bin
echo -e "$password" | sudo -v -S
installAurPackage powershell-bin
echo -e "$password" | sudo -v -S
installAurPackage netcoredbg

installAurPackage i3lock-color
installAurPackage i3exit

installAurPackage betterlockscreen
betterlockscreen -u ~/.dotfiles/images
# lock on sleep/suspend
echo -e "$password" | sudo -v -S
sudo systemctl enable betterlockscreen@$USER

# installAurPackage forticlient-vpn
# sudo pacman -S networkmanager-fortisslvpn

installAurPackage openfortivpn
# ALSO NEED TO RUN THE FOLLOWING FOR THE NETWORKING TO WORK CORRECTLY FOR THE VPN:
echo -e "$password" | sudo -v -S
sudo systemctl enable systemd-resolved.service
sudo systemctl start systemd-resolved.service

installAurPackage icaclient #Citrix workspace app/Citrix receiver
echo -e "$password" | sudo -v -S
sudo pacman --noconfirm --needed -Syu perl-file-mimeinfo # Required to interpret the *.ica files correctly
# COPYING AND PASTING NOT WORKING IN icaclient, DISABLE KLIPPER OR CLIPBOARD MANAGER!

installAurPackage nvm
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts

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

