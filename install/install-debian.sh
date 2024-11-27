#!/bin/bash
set -e

GREEN='\033[32m'
RESET='\033[0m'

pushd ~

# echo -e "${GREEN}----------------------------------------${RESET}"
# echo -e "${GREEN}Adding Neovim package repository${RESET}"
# echo -e "${GREEN}----------------------------------------${RESET}"
# sudo add-apt-repository -y ppa:neovim-ppa/unstable


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Adding Alacritty package repository${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
sudo add-apt-repository -y ppa:aslatter/ppa


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Updating Linux${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
sudo apt update
sudo apt -y upgrade


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Installing software${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"

sudo apt install -y \
	alacritty \
	btop \
	build-essential \
	curl \
	fd-find \
	feh \
	git \
	i3 \
	ncdu \
	ranger \
	ripgrep \
	stow \
	timeshift \
	tmux \
	unzip \
	xclip \
	xrdp \
	zip


read -p 'Install apt-btrfs-snapshot? (y/n) ' -n 1 -r install_apt_btrfs_snapshot
if [[ $install_apt_btrfs_snapshot =~ ^[Yy]$ ]]
then
		echo -e "${GREEN}----------------------------------------${RESET}"
		echo -e "${GREEN}Installing apt-btrfs-snapshot${RESET}"
		echo -e "${GREEN}----------------------------------------${RESET}"
		sudo apt install -y apt-btrfs-snapshot python3-distutils
fi

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Install Neovim${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
pushd /tmp
curl -LOJ https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar xvf nvim-linux64.tar.gz
sudo cp nvim-linux64/bin/nvim /usr/local/bin
sudo cp -r nvim-linux64/share/* /usr/local/share
sudo cp -r nvim-linux64/lib/nvim /usr/lib
sudo chmod +x /usr/local/bin/nvim
popd


# config fd
[ -d ~/.local/bin ] || mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Configure SSH Keys${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
[ ! -d "~/.ssh" ] && ssh-keygen

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Configure Git${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
git config --global user.email "albert@gouws.org"
git config --global user.name "Albert Gouws"


# echo Installing Chrome
# echo ----------------------------------------
# if [ $(dpkg-query -W -f='${Status}' google-chrome-stable 2>/dev/null | grep -c "ok installed") -eq 0 ];
# then
#		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
#			sudo dpkg -i google-chrome-stable_current_amd64.deb &&
#			rm -f google-chrome-stable_current_amd64.deb
# else
#		echo "Chrome found, not adding it"
# fi


# echo Clone dotfiles
# echo ----------------------------------------
# git clone https://github.com/KiLLeRRaT/.dotfiles.git


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Config xrdp to start with i3${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
# EDIT /etc/xrdp/startwm.sh
# COMMENT OUT THIS LINE
#exec /bin/sh /etc/X11/Xsession
# ADD THIS LINE
#/usr/bin/i3
if grep -q "/usr/bin/i3" "/etc/xrdp/startwm.sh" ; then
	# exists
	echo "/usr/bin/i3 found, not adding it"
else
	# not exist

	sudo sed -Ei.bak 's|test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession|# test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession|' /etc/xrdp/startwm.sh
	sudo sed -Ei.bak 's|exec /bin/sh /etc/X11/Xsession|# exec /bin/sh /etc/X11/Xsession|' /etc/xrdp/startwm.sh
	#sudo echo "/usr/bin/i3" >> /etc/xrdp/startwm.sh # DOES NOT WORK FOR SUDO.. USE BELOW
	echo "/usr/bin/i3" | sudo tee -a /etc/xrdp/startwm.sh
fi


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Running stow${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
STOW_FOLDERS=bashrc,fonts,i3,inputrc,nvim-lua,oh-my-posh,tmux,dosbox,gitconfig,zshrc,alacritty
pushd ~/.dotfiles
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
	read -p "Stow $folder? (y/n) " -n 1 -r stow_current_folder
	echo ""
	if [[ $stow_current_folder =~ ^[Yy]$ ]]
	then
		[ -a ~/.$folder ] && echo "Move existing file to ~/.$folder.stowbak" && mv ~/.$folder ~/.$folder.stowbak
		echo Running stow $folder
		stow -D $folder
		stow $folder
	fi
done
popd


# echo -e "${GREEN}----------------------------------------${RESET}"
# echo -e "${GREEN}Now install the VIM plugins${RESET}"
# echo -e "${GREEN}----------------------------------------${RESET}"
# echo Installing Vim Plug
# sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
# 			 https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# echo Running PlugInstall
# nvim --headless +PlugInstall +qall


# echo -e "${GREEN}----------------------------------------${RESET}"
# echo -e "${GREEN}Build fzf for use in Telescope${RESET}"
# echo -e "${GREEN}----------------------------------------${RESET}"
# pushd ~/.local/share/nvim/plugged/telescope-fzf-native.nvim
# make
# popd


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Install oh-my-posh${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Install nvm to manage NodeJS${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
exec bash
nvm install --lts
nvm use --lts


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Swap Control and Capslock keys${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
# FROM: https://askubuntu.com/a/418773
# sudo vim /etc/default/keyboard
# XKBOPTIONS="ctrl:swapcaps"
# XKBOPTIONS="ctrl:nocaps"
# sudo dpkg-reconfigure keyboard-configuration
# PROBABLY TRY THIS IN THE FUTURE, SO THAT WE CAN KEEP CONTROL AS CONTROL AND MAKE CAPSLOCK CONTROL
# TOO, https://askubuntu.com/a/418773

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Configure Touchpad${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
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

# RESILIO SYNC
# echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
# curl -L https://linux-packages.resilio.com/resilio-sync/key.asc | sudo apt-key add
# sudo apt update && sudo apt install resilio-sync
# sudo usermod -aG albert rslsync && \
# sudo usermod -aG rslsync albert && \
# sudo chmod g+rw ~/resilio-sync
# sudo systemctl enable resilio-sync

popd
