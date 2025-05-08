#!/bin/bash
set -e

GREEN='\033[32m'
RESET="\033[0m"

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Installing software${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"

apt install -y \
	bat \
	btop \
	build-essential \
	cmake \
	curl \
	fd-find \
	git \
	i3 \
	ncdu \
	ranger \
	ripgrep \
	stow \
	tmux \
	tree \
	unzip \
	zip \
	zsh

# config fd
[ -d ~/.local/bin ] || mkdir -p ~/.local/bin
ln -s $(which fdfind) /usr/bin/fd

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Change Shell to Zsh${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
chsh -s $(which zsh)


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Configure Git${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
git config --global user.email "albert@gouws.org"
git config --global user.name "Albert Gouws"


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Running stow${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
STOW_FOLDERS=nvim-lua,oh-my-posh,tmux,gitconfig,zshrc
pushd ~/.dotfiles
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
	# read -p "Stow $folder? (y/n) " -n 1 -r stow_current_folder
	# echo ""
	# if [[ $stow_current_folder =~ ^[Yy]$ ]]
	# then
		[ -a ~/.$folder ] && echo "Move existing file to ~/.$folder.stowbak" && mv ~/.$folder ~/.$folder.stowbak
		echo Running stow $folder
		stow -D $folder
		stow $folder
	# fi
done
popd

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Install Neovim${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
./install-nvim-from-tar.sh

# echo -e "${GREEN}----------------------------------------${RESET}"
# echo -e "${GREEN}Build fzf for use in Telescope${RESET}"
# echo -e "${GREEN}----------------------------------------${RESET}"
# pushd ~/.local/share/nvim/plugged/telescope-fzf-native.nvim
# make
# popd

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Install oh-my-posh${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
chmod +x /usr/local/bin/oh-my-posh


echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Install nvm to manage NodeJS${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
# exec bash
source ~/.bashrc
nvm install --lts
nvm use --lts

