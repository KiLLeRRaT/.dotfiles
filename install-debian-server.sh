#!/bin/bash

# pushd ~
# echo -e "\033[32m ----------------------------------------\033[0m"
# echo -e "\033[32m Adding Neovim package repository\033[0m"
# echo -e "\033[32m ----------------------------------------\033[0m"
# add-apt-repository -y ppa:neovim-ppa/unstable


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing software\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
apt install -y git && \
apt install -y curl && \
apt install -y stow && \
apt install -y neovim && \
apt install -y xclip && \
apt install -y ripgrep && \
apt install -y fd-find && \
apt install -y build-essential && \
apt install -y tmux && \
apt install -y btop && \
apt install -y ranger
# apt install -y ncdu # NOT SURE IF THIS COMES WITH DEBIAN BASED SYSTEMS?

# config fd
[ -d ~/.local/bin ] || mkdir -p ~/.local/bin
ln -s $(which fdfind) /usr/bin/fd

# echo -e "\033[32m ----------------------------------------\033[0m"
# echo -e "\033[32m Configure SSH Keys\033[0m"
# echo -e "\033[32m ----------------------------------------\033[0m"
# [ ! -d "~/.ssh" ] && ssh-keygen

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


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Build fzf for use in Telescope\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
pushd ~/.local/share/nvim/plugged/telescope-fzf-native.nvim
make
popd


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


# RESILIO SYNC
# echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | tee /etc/apt/sources.list.d/resilio-sync.list
# curl -L https://linux-packages.resilio.com/resilio-sync/key.asc | apt-key add
# apt update && apt install resilio-sync
# usermod -aG albert rslsync && \
# usermod -aG rslsync albert && \
# chmod g+rw ~/resilio-sync
# systemctl enable resilio-sync

popd
