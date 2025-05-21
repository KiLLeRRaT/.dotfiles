#!/bin/bash
set -e
USERNAME=albert
echo "I am: " && whoami


sudo pacman -Sy --needed \
	aspnet-runtime \
	base-devel \
	bat \
	bc \
	btop \
	cmake \
	curl \
	dmenu \
	docker docker-compose \
	dotnet-runtime \
	dotnet-sdk \
	dunst \
	fd \
	feh \
	flameshot xdotool \
	fzf \
	git \
	gnome-keyring seahorse lxsession-gtk3 \
	i3 \
	inotify-tools \
	iotop \
	jq \
	less \
	lightdm \
	lightdm-slick-greeter \
	lsof \
	man \
	mono \
	mono-msbuild \
	ncdu \
	neovim \
	nginx \
	noto-fonts \
	noto-fonts-emoji \
	noto-fonts-extra \
	nuget \
	openssh \
	pacman-contrib \
	pcmanfm \
	picom \
	polkit \
	ranger ueberzug \
	redshift \
	remmina freerdp libvncserver \
	ripgrep \
	rsync \
	silicon \
	spotify-launcher \
	sshfs \
	stow \
	sudo \
	systemd \
	tesseract-data-eng \
	tmux \
	tokei \
	tree \
	ttf-cascadia-code-nerd \
	udisks2 udisks2-btrfs udiskie \
	unzip \
	wget \
	wireplumber pipewire-pulse pavucontrol playerctl \
	xclip \
	xdg-user-dirs \
	xorg \
	xorg-xinit \
	xorg-xkill \
	xorg-xrandr \
	zathura zathura-pdf-poppler \
	zip \
	zoxide \
	zsh

sudo sed -i 's/#en_NZ.UTF-8 UTF-8/en_NZ.UTF-8 UTF-8/g' /etc/locale.gen
sudo locale-gen
sudo echo "LANG=en_NZ.UTF-8" > /etc/locale.conf

sudo sed -i 's/^#Color/Color/g' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/g' /etc/pacman.conf


## TODO: This could probably come from stow....?
#sudo sed -i.bak 's|^#greeter-session=.*$|greeter-session=lightdm-slick-greeter|' /etc/lightdm/lightdm.conf

sudo echo -e "${GREEN}Enable services${RESET}"
sudo systemctl enable lightdm.service
sudo systemctl enable sshd
sudo systemctl enable paccache.timer
sudo systemctl enable docker

sudo echo -e "${GREEN}Configuring makepkg${RESET}"
# DISABLE COMPRESSION
sudo sed -i 's/^PKGEXT.*/PKGEXT=".pkg.tar"/' /etc/makepkg.conf
# DISABLE DEBUGGING
sudo sed -i 's/\(OPTIONS=.*\)debug/\1!debug/' /etc/makepkg.conf


echo -e "${GREEN}Creating xdg-user-dirs{RESET}" # FOR 1Password download dir and other apps that use XDG directories
sudo  xdg-user-dirs-update

#echo -e "${GREEN}Generating host config${RESET}"
#sudo /home/$USERNAME/.dotfiles/nvim-lua/.config/nvim/generateHostConfig.sh

echo -e "${GREEN}Let's copy our gtk configs to /root, so that root has the same theme${RESET}"
sudo cp /home/$USERNAME/.dotfiles/gtk-2.0/.gtkrc-2.0 /root
sudo mkdir -p /root/.config
sudo cp -r /home/$USERNAME/.dotfiles/gtk-3.0/.config/gtk-3.0 /root/.config
sudo cp -r /home/$USERNAME/.dotfiles/gtk-4.0/.config/gtk-4.0 /root/.config

sudo chsh -s /bin/zsh albert


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Installing AUR Packages${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"


mkdir -p /home/$USERNAME/source-aur
pushd /home/$USERNAME/source-aur
git clone https://aur.archlinux.org/yay
cd yay
sudo pacman -S go --needed --noconfirm
makepkg -is
popd

yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save


#cp /etc/pam.d/login /etc/pam.d/login.bak
#cat <<- EOF > /etc/pam.d/login
#	#%PAM-1.0
#	auth       required     pam_securetty.so
#	auth       requisite    pam_nologin.so
#	auth       include      system-local-login
#	auth       optional     pam_gnome_keyring.so
#	account    include      system-local-login
#	session    include      system-local-login
#	session    optional     pam_gnome_keyring.so auto_start
#	password   include      system-local-login
#EOF


#cp /usr/lib/pam.d/polkit-1 /etc/pam.d/polkit-1

sudo pacman -Sy --noconfirm --needed \
	p7zip \
	python-dbus \
	python-setuptools \
	gtksourceview3 \
	libkeybinder3 \
	python-setproctitle \
	python-pipenv \
	xcb-util-xrm \
	imagemagick \
	i3-wm

sudo pacman -R --noconfirm i3lock

yay -S \
	oh-my-posh-bin \
	otf-san-francisco \
	pa-applet-git \
	dracula-gtk-theme \
	dracula-icons-git \
	as-tree \
	otf-san-francisco-mono \
	nvm \
	emote \
	i3lock-color \
	i3exit \
	betterlockscreen



# PROBLEMS WITH DOTNET OR SOMETHING, MAYBE JUST CHROOT RELATED??? LEAVE FOR NOW
# pacman -Sy --noconfirm --needed cmake clang
# installAurPackage netcoredbg

betterlockscreen -u /home/$USERNAME/.dotfiles/images

# TODO: VERIFY THAT THIS WORKED, CANT IN THE CHROOT RIGHT NOW...
sudo systemctl enable betterlockscreen@$USERNAME
# lock on sleep/suspend


source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts

mkdir -p /home/$USERNAME/Pictures/screenshots

sudo ln -s /home/$USERNAME/.dotfiles/scripts/dmenu_recency /usr/local/bin/dmenu_recency



echo -e "${GREEN}Done${RESET}"



