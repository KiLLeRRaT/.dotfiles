#!/bin/bash
set -e

GREEN='\033[32m'
RESET='${RESET}'

echo -e "${GREEN}----------------------------------------${RESET}"
echo -e "${GREEN}Installing software${RESET}"
echo -e "${GREEN}----------------------------------------${RESET}"
sudo apt install -y git && \
sudo apt install -y curl && \
sudo apt install -y stow && \
sudo apt install -y xclip && \
sudo apt install -y ripgrep && \
sudo apt install -y fd-find && \
sudo apt install -y build-essential && \
sudo apt install -y tmux && \
sudo apt install -y btop && \
sudo apt install -y ranger && \
sudo apt install -y zsh && \
sudo apt install -y tree && \
sudo apt install -y bat && \
sudo apt install -y cmake
# apt install -y ncdu # NOT SURE IF THIS COMES WITH DEBIAN BASED SYSTEMS?

# config fd
[ -d ~/.local/bin ] || mkdir -p ~/.local/bin
sudo ln -s $(which fdfind) /usr/bin/fd

# echo -e "${GREEN}----------------------------------------${RESET}"
# echo -e "${GREEN}Configure SSH Keys${RESET}"
# echo -e "${GREEN}----------------------------------------${RESET}"
# [ ! -d "~/.ssh" ] && ssh-keygen

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
pushd /tmp
curl -LOJ https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar xvf nvim-linux64.tar.gz
sudo cp nvim-linux64/bin/nvim /usr/local/bin
sudo cp -r nvim-linux64/share/nvim /usr/share
sudo cp -r nvim-linux64/lib/nvim /usr/lib
popd


# echo -e "${GREEN}----------------------------------------${RESET}"
# echo -e "${GREEN}Build Neovim from source${RESET}"
# echo -e "${GREEN}----------------------------------------${RESET}"
# mkdir -p ~/source-github
# pushd ~/source-github
# git clone https://github.com/neovim/neovim
# cd neovim
# git checkout stable
# apt install -y ninja-build gettext cmake unzip curl
# make CMAKE_BUILD_TYPE=Release
# make install
# popd
# USE SNAP TO INSTALL NEOVIM INSTEAD
sudo snap install neovim --classic


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
nvm install --lts
nvm use --lts

