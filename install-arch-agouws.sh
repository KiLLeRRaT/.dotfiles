#!/bin/bash


# TODO:
# - [x] Bridge br0
# - [x] VMs
# - [x] forticlient-vpn
# - [ ] Firewall
# - [ ] Sourcecode backups
# - [ ] Machine backups
# - [ ] nginx
# - [ ] unlock /mnt/data automatically
# - [ ] ssh unlock luks

# - [ ] Pacman hooks into installer script
# - [ ] systemd services int installer script??
# - [ ] /etc/fonts/local.conf in installer script
# - [ ] /etc/X11/xorg.conf.d/ into installer script


# Exit when any command fails
set -e

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing Arch Linux\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

echo "Installing more packages"
pacman --noconfirm -Syu \
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
	flameshot \
	fzf \
	git \
	gnome-keyring seahorse \
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
	ranger \
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
	signal-desktop discord

echo "Starting sshd"
sudo systemctl start sshd
sudo systemctl enable sshd

echo "Starting cronie, so that timeshift scheduled snapshots work"
sudo systemctl enable cronie.service 
sudo systemctl start cronie.service

echo "Starting Bluetooth"
sudo systemctl start bluetooth
sudo systemctl enable bluetooth


echo "Reboot now, and continue the script from the new system as root"
exit 1


echo "Starting NetworkManager"
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

username=albert

echo "Cloning dotfiles"
pushd /home/$username
git clone https://github.com/killerrat/.dotfiles
popd


echo "From here, run as the user in the new system"
exit 1

echo "Running stow"
pushd ~/.dotfiles/hosts/arch-agouws
stow -t ~ xinitrc
popd

pushd ~/.dotfiles
stow alacritty dmenurc dosbox dunst fonts gitconfig gtk-2.0 gtk-3.0 gtk-4.0 i3-manjaro nvim-lua oh-my-posh picom ranger tmux zshrc
popd


echo "Generate host specific configs"
~/.dotfiles/nvim-lua/.config/nvim/generateHostConfig.sh


echo "Let's copy our gtk configs to /root, so that root has the same theme"
sudo cp /home/albert/.dotfiles/gtk-2.0/.gtkrc-2.0 /root
sudo mkdir -p /root/.config
sudo cp -r /home/albert/.dotfiles/gtk-3.0/.config/gtk-3.0 /root/.config
sudo cp -r /home/albert/.dotfiles/gtk-4.0/.config/gtk-4.0 /root/.config


sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
echo "If running on the MacBook, you need to set up brcmfmac43602-pcie. Do you want to set up brcmfmac43602-pcie? (y/n)"
read setup_brcmfmac43602_pcie
if [ "$setup_brcmfmac43602_pcie" == "y" ]; then
	sudo cp /home/$USER/.dotfiles/hosts/arch-agouwsmacbookpro/brcmfmac43602-pcie.txt /lib/firmware/brcm/.
	sudo cp /home/$USER/.dotfiles/hosts/arch-agouwsmacbookpro/brcmfmac43602-pcie.txt /lib/firmware/brcm/brcmfmac43602-pcie.Apple\ Inc.-MacBookPro13,3.txt
fi
sudo systemctl restart NetworkManager.service

chsh -s /bin/zsh albert

echo "From here, run as the user in X"
exit 1


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing AUR Packages\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

mkdir ~/source-aur

installAurPackage() {
	pushd ~/source-aur
	echo "Installing $1"
	git clone https://aur.archlinux.org/$1.git
	cd $1
	makepkg --noconfirm -is
	popd
}

installAurPackage oh-my-posh
installAurPackage brave-bin

echo "If running on the MacBook, you probably want to install macbook12-spi-driver-dkms. Also swap fn and ctrl, and permanently make the F keys display on the touchbar. Do you want to do this? (y/n)"
read update_mkinitcpio_fnremap
if [ "$update_mkinitcpio_fnremap" == "y" ]; then
	installAurPackage macbook12-spi-driver-dkms
	sudo sed -i.bak3 '/^MODULES=(/c\MODULES=(apple_ib_tb applespi intel_lpss_pci spi_pxa2xx_platform)' /etc/mkinitcpio.conf
	echo 'options apple_ib_tb fnmode=2' | sudo tee /etc/modprobe.d/apple_ib_tb.conf
	echo 'options apple_ib_tb idle_timeout=60' | sudo tee --append /etc/modprobe.d/apple_ib_tb.conf
	echo 'options applespi fnremap=1' | sudo tee /etc/modprobe.d/applespi.conf
	sudo mkinitcpio -P
fi


echo "Set up seahorse and create a default keyring. This is needed for 1Password otherwise it keeps asking the 2FA prompt again and again."
# FROM: https://1password.community/discussion/127523/1password-and-gnome-keyring-for-2fa-saving-on-archlinux
seahorse


curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
installAurPackage 1password
echo Need to make sure gnome-keyring is correctly setup otherwise 2fa keys wont be remembered.

cp /etc/pam.d/login /tmp/login.tmp
sudo bash -c "cat > /etc/pam.d/login" << 'EOF'
#%PAM-1.0
auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so # ADD THIS LINE AT END OF AUTH
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start # ADD THIS LINE AT END OF SESSION
password   include      system-local-login
EOF

read -p "Let's verify the changes. Press enter to continue"
sudo nvim -d /etc/pam.d/login /tmp/login.tmp

installAurPackage i3exit

sudo pacman --noconfirm -S python-antlr4 python-semantic-version python-systemd python-tomlkit python-typeguard python-watchdog refind
installAurPackage python-injector
installAurPackage python-pid
installAurPackage python-transitions
installAurPackage refind-btrfs
installAurPackage refind-theme-dracula
installAurPackage gmux_backlight
installAurPackage otf-san-francisco
installAurPackage otf-san-francisco-mono
installAurPackage pa-applet-git
installAurPackage dracula-gtk-theme
installAurPackage dracula-icons-git
installAurPackage azuredatastudio-bin
installAurPackage snapper-gui-git

installAurPackage i3lock-color
installAurPackahe betterlockscreen
betterlockscreen -u ~/.dotfiles/images

# installAurPackage forticlient-vpn
# sudo pacman -S networkmanager-fortisslvpn

installAurPackage openfortivpn
# ALSO NEED TO RUN THE FOLLOWING FOR THE NETWORKING TO WORK CORRECTLY FOR THE VPN:
systemctl enable systemd-resolved.service
systemctl start systemd-resolved.service

installAurPackage icaclient #Citrix workspace app/Citrix receiver
# COPYING AND PASTING NOT WORKING IN icaclient, DISABLE KLIPPER OR CLIPBOARD MANAGER!



installAurPackage nvm
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts


echo "If running on the MacBook, you need to install snd_hda_macbookpro. Do you want to do this? (y/n)"
read snd_hda_macbookpro
if [ "$snd_hda_macbookpro" == "y" ]; then
	pushd ~/source-aur
	git clone https://github.com/davidjo/snd_hda_macbookpro.git
	cd snd_hda_macbookpro/
	#run the following command as root or with sudo
	sudo ./install.cirrus.driver.sh
	echo "You need to reboot after doing the Sound Install. Do you want to reboot? (y/n)"
	read reboot
	if [ "$reboot" == "y" ]; then
		sudo reboot now
	fi
fi
sudo pacman -S wireplumber pipewire-pulse pulseaudio pavucontrol playerctl
popd


echo Configure dmenu
sudo ln -s ~/.dotfiles/scripts/dmenu_recency /usr/local/bin/dmenu_recency


echo "Enable and start Docker? (y/n)"
read enable_docker
if [ "$enable_docker" == "y" ]; then
	sudo systemctl enable docker
	sudo systemctl start docker
fi

echo "Sort out the terminal TTY screen buffer size"
sudo cp ~/.dotfiles/hosts/arch-agouwsmacbookpro/etc/systemd/system/set-display-resolution.service /etc/systemd/system/set-display-resolution.service
sudo systemctl enable set-display-resolution.service
sudo systemctl start set-display-resolution.service

# sudo cp ~/.dotfiles/hosts/arch-agouwsmacbookpro/etc/systemd/system/disable-dgpu.service /etc/systemd/system/disable-dgpu.service
# sudo systemctl enable disable-dgpu.service
# sudo systemctl start disable-dgpu.service

echo Configure graphics to use Intel only
echo "blacklist amdgpu" | sudo tee /etc/modprobe.d/blacklist-amdgpu.conf
pushd ~/source-aur
git clone https://github.com/0xbb/gpu-switch
cd gpu-switch
sudo ./gpu-switch -i
echo "You need to reboot after doing the Graphics Config to blacklist AMD GPU. Do you want to reboot? (y/n)"
read reboot
if [ "$reboot" == "y" ]; then
	sudo reboot now
fi
popd



