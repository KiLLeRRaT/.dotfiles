#!/bin/bash
set -e

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing software\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
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

# echo -e "\033[32m ----------------------------------------\033[0m"
# echo -e "\033[32m Configure SSH Keys\033[0m"
# echo -e "\033[32m ----------------------------------------\033[0m"
# [ ! -d "~/.ssh" ] && ssh-keygen

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Change Shell to Zsh\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
chsh -s $(which zsh)


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure Git\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
git config --global user.email "albert@gouws.org"
git config --global user.name "Albert Gouws"


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Running stow\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
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


# echo -e "\033[32m ----------------------------------------\033[0m"
# echo -e "\033[32m Build Neovim from source\033[0m"
# echo -e "\033[32m ----------------------------------------\033[0m"
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


# echo -e "\033[32m ----------------------------------------\033[0m"
# echo -e "\033[32m Build fzf for use in Telescope\033[0m"
# echo -e "\033[32m ----------------------------------------\033[0m"
# pushd ~/.local/share/nvim/plugged/telescope-fzf-native.nvim
# make
# popd


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Install oh-my-posh\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
chmod +x /usr/local/bin/oh-my-posh


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Install nvm to manage NodeJS\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
# exec bash
nvm install --lts
nvm use --lts

