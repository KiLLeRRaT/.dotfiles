#!/bin/bash
pushd ~
echo Updating Linux
apt update
apt upgrade

# Install i3
# Install curl
# Install xrdp
# Install stow
echo Installing git, xrdp, i3, curl, stow
apt install git xrdp i3 curl stow

# Install Neovim
echo Installing Neovim
add-apt-repository ppa:neovim-ppa/unstable
apt update
apt install neovim

echo Clone dotfiles
git clone git@github.com:KiLLeRRaT/.dotfiles.git

echo Config xrdp to start with i3
# EDIT /etc/xrdp/startwm.sh
# COMMENT OUT THIS LINE
#exec /bin/sh /etc/X11/Xsession
# ADD THIS LINE
#/usr/bin/i3
sed -Ei.bak 's|test -x /etc/X11/Xsession && exec /etc/X11/Xsession|# test -x /etc/X11/Xsession && exec /etc/X11/Xsession|' /etc/xrdp/startwm.sh
sed -Ei.bak 's|/bin/sh /etc/X11/Xsession/|# /bin/sh /etc/X11/Xsession|' /etc/xrdp/startwm.sh
echo "/usr/bin/i3" >> /etc/xrdp/startwm.sh

# Run stow to set up dotfiles
echo Running stow
$STOW_FOLDERS=i3,nvim,bashrc
pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
