#!/bin/bash

pushd ~
echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Adding Neovim package repository\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
sudo add-apt-repository -y ppa:neovim-ppa/unstable


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Adding Alacritty package repository\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
sudo add-apt-repository ppa:aslatter/ppa


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Updating Linux\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
sudo apt update
sudo apt -y upgrade


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing software\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
sudo apt install -y git && \
sudo apt install -y xrdp && \
sudo apt install -y i3 && \
sudo apt install -y curl && \
sudo apt install -y stow && \
sudo apt install -y neovim && \
sudo apt install -y xclip && \
sudo apt install -y ripgrep && \
sudo apt install -y fd-find && \
sudo apt install -y feh && \
sudo apt install -y build-essential && \
sudo apt install -y tmux

# config fd
[ -d ~/.local/bin ] || mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure Git\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
git config --global user.email "albert@gouws.org"
git config --global user.name "Albert Gouws"


# echo Installing Chrome
# echo ----------------------------------------
# if [ $(dpkg-query -W -f='${Status}' google-chrome-stable 2>/dev/null | grep -c "ok installed") -eq 0 ];
# then
# 	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
#     sudo dpkg -i google-chrome-stable_current_amd64.deb &&
#     rm -f google-chrome-stable_current_amd64.deb
# else
# 	echo "Chrome found, not adding it"
# fi


echo Clone dotfiles
echo ----------------------------------------
git clone https://github.com/KiLLeRRaT/.dotfiles.git


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Config xrdp to start with i3\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
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


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Running stow\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
STOW_FOLDERS=bashrc,fonts,i3,inputrc,nvim,oh-my-posh,tmux
pushd ~/.dotfiles
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo Running stow $folder in $PWD
    stow -D $folder
    stow $folder
done
popd


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Now install the VIM plugins\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
echo Installing Vim Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo Running PlugInstall
nvim --headless +PlugInstall +qall


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Build fzf for use in Telescope\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
pushd ~/.local/share/nvim/plugged/telescope-fzf-native.nvim
make
popd


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Install oh-my-posh\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Install nvm to manage NodeJS\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
exec bash
nvm install --lts
nvm use --lts


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Swap Control and Capslock keys\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
# FROM: https://askubuntu.com/a/418773
# sudo vim /etc/default/keyboard
# XKBOPTIONS="ctrl:swapcaps"
# XKBOPTIONS="ctrl:nocaps"
# sudo dpkg-reconfigure keyboard-configuration
# PROBABLY TRY THIS IN THE FUTURE, SO THAT WE CAN KEEP CONTROL AS CONTROL AND MAKE CAPSLOCK CONTROL
# TOO, https://askubuntu.com/a/418773

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure Touchpad\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
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


popd
