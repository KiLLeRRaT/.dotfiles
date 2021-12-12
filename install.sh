#!/bin/bash
pushd ~
echo Adding Neovim package repository
sudo add-apt-repository ppa:neovim-ppa/unstable


echo Updating Linux
sudo apt update
sudo apt -y upgrade


echo Installing git, xrdp, i3, curl, stow
sudo apt install -y git xrdp i3 curl stow neovim chrome-browser xclip

echo Installing Chrome
if [ $(dpkg-query -W -f='${Status}' chrome-browser 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
    rm -f google-chrome-stable_current_amd64.deb
else
	echo "Chrome found, not adding it"
fi


echo Clone dotfiles
git clone https://github.com/KiLLeRRaT/.dotfiles.git


echo Config xrdp to start with i3
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

echo Running stow
STOW_FOLDERS=i3,nvim,bashrc
pushd ~/.dotfiles
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo Running stow $folder in $PWD
    stow -D $folder
    stow $folder
done
popd

# NOW INSTALL THE VIM PLUGINS
nvim --headless +PlugInstall +q

popd
