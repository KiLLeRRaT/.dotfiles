#!/bin/sh

sudo apt update
sudo apt upgrade

# Install i3
# Install curl
# Install xrdp
# Install stow
sudo apt install git xrdp i3 curl stow

# Install Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# CONFIG xrdp to start with i3
# EDIT /etc/xrdp/startwm.sh
# COMMENT OUT THIS LINE
#exec /bin/sh /etc/X11/Xsession
# ADD THIS LINE
#/usr/bin/i3

# Run stow to set up dotfiles
$STOW_FOLDERS="i3,nvim,bashrc"
pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
"stow i3
"stow nvim
"stow bashrc
