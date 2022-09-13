#!/bin/zsh

# Exit when any command fails
set -e

# USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
USER_RECORD="$(getent passwd $SUDO_USER)"
USER_GECOS_FIELD="$(echo "$USER_RECORD" | cut -d ':' -f 5)"
USER_HOME="$(echo "$USER_RECORD" | cut -d ':' -f 6)"
USER_FULL_NAME="$(echo "$USER_GECOS_FIELD" | cut -d ',' -f 1)"


pushd $USER_HOME

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Updating Linux\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
pamac update && \
pamac upgrade --no-confirm
echo -e "Done"

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing software\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

function installApp() {
	read -k 1 -r "install?Install $1? (y/n) "
	echo -e ""
	if [[ $install =~ ^[Yy]$ ]]
	then
		echo Installing $1
		sudo pamac install --no-confirm $1
	fi
}

function buildApp() {
	read -k 1 -r "build?Install $1? (y/n) "
	echo -e ""
	if [[ $build =~ ^[Yy]$ ]]
	then
		echo Installing $1
		sudo pamac build --no-confirm $1
	fi
}

# WE HAVE TO BUILD XRDP...
pamac build --no-confirm xrdp
pamac install --no-confirm git
pamac install --no-confirm curl
pamac install --no-confirm stow
pamac install --no-confirm neovim
pamac install --no-confirm xclip
pamac install --no-confirm ripgrep
pamac install --no-confirm fd
pamac install --no-confirm alacritty
pamac install --no-confirm timeshift
pamac install --no-confirm tmux
pamac install --no-confirm btop
pamac install --no-confirm unzip

installApp redshift
installApp signal-desktop
installApp timeshift-autosnap-manjaro

buildApp rslsync
buildApp azuredatastudio-bin

#pamac install snapd --no-confirm
#systemctl enable --now snapd.socket
#ln -s /var/lib/snapd/snap /snap
#echo -e "Done"
# snap install google-chat-electron

installApp brave-browser


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure SSH Keys\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
[ ! -d "$USER_HOME/.ssh" ] && mkdir $USER_HOME/.ssh && ssh-keygen -q -N "" -f $USER_HOME/.ssh/id_rsa
chown -R $SUDO_USER $USER_HOME/.ssh
echo -e "Done"


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Configure Git\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
read  -r "git_email?Enter Git email address: "
git config --global user.email $git_email
git config --global user.name $USER_FULL_NAME
echo -e "Done"


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

	sed -Ei.bak 's|test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession|# test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession|' /etc/xrdp/startwm.sh
	sed -Ei.bak 's|exec /bin/sh /etc/X11/Xsession|# exec /bin/sh /etc/X11/Xsession|' /etc/xrdp/startwm.sh
	#echo "/usr/bin/i3" >> /etc/xrdp/startwm.sh # DOES NOT WORK FOR SUDO.. USE BELOW
	echo "/usr/bin/i3" | tee -a /etc/xrdp/startwm.sh
fi
echo -e "Done"


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Running stow\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
STOW_FOLDERS=bashrc,fonts,i3,inputrc,nvim,oh-my-posh,tmux,dosbox,gitconfig,zshrc,alacritty
pushd $USER_HOME/.dotfiles
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
	read -k 1 -r "stow_current_folder?Stow $folder? (y/n) "
	echo ""
	if [[ $stow_current_folder =~ ^[Yy]$ ]]
	then
		[[ -a $USER_HOME/.$folder ]] && echo "Move existing file to $USER_HOME/.$folder.stowbak" && mv $USER_HOME/.$folder $USER_HOME/.$folder.stowbak
		echo Running stow $folder
		stow -D $folder
		stow $folder
	fi
done
popd
echo -e "Done"


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Now install the VIM plugins\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
echo Installing Vim Plug
curl -fLo $USER_HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
chown -R $SUDO_USER $USER_HOME/.local/share/nvim
echo Running PlugInstall
source $USER_HOME/.zshrc
export XDG_CONFIG_HOME=$USER_HOME/.config
export XDG_DATA_HOME=$USER_HOME/.local/share
nvim -u $USER_HOME/.config/nvim/init.vim --headless +PlugInstall +qall
chown -R $SUDO_USER $XDG_CONFIG_HOME
chown -R $SUDO_USER $XDG_DATA_HOME
echo -e "Done"


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Build fzf for use in Telescope\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
pushd $USER_HOME/.local/share/nvim/plugged/telescope-fzf-native.nvim
make
popd
echo -e "Done"


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Install oh-my-posh\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
chmod +x /usr/local/bin/oh-my-posh
echo -e "Done"


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Install nvm to manage NodeJS\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source $USER_HOME/.zshrc
nvm install --lts
nvm use --lts
echo -e "Done"


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Change default shell to zsh\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
chsh -s /bin/zsh root
chsh -s /bin/zsh albert
echo -e "Done"

popd

# NOTES

# TO DO
 # - [x] Install timeshift
 # - [x] Create snapshot
 # - [x] Set up timeshift to create snapshots automatically when running updates
 # - [x] Run install-manjaro.sh
 # - [x] Setup ssh server
 # - [x] Install btop
 # - [x] Install NVidia drivers
 # - [x] Install .NET 6
 # - [x] Install Resilio sync
 # - [ ] Set up xrdp


# ----------------------------------------
# DISPLAY LAYOUT
# ----------------------------------------
## Display layout
# https://stackoverflow.com/questions/56618874/how-can-i-permanently-setting-the-screen-layout-arandr-in-manjaro-i3
# 1. Open arandr
# 2. Set your desired layout
# 3. Export it
# 4. sudo vim /etc/lightdm/Xsession
# 5. Add the exported code *before* the last line
# 6. Reboot

# ----------------------------------------
# Mouse sensitivity
# ----------------------------------------
# https://www.reddit.com/r/linux4noobs/comments/98kicg/set_mouse_speed_sensitivity_in_manjaro_i3/
# https://wiki.archlinux.org/title/Libinput#Via_xinput
# https://www.reddit.com/r/linux4noobs/comments/hnhehw/change_pointer_speed_in_manjaro/


# ----------------------------------------
# NVIDIA DRIVERS
# ----------------------------------------
# https://linuxconfig.org/how-to-install-the-nvidia-drivers-on-manjaro-linux
# sudo mhwd -a pci nonfree 0300
# sudo reboot
# nvidia-settings


# ----------------------------------------
# KILL X USING CTRL+ALT+BACKSPACE
# ----------------------------------------
# https://unix.stackexchange.com/a/445
# Modify /etc/X11/xorg.conf or a .conf file in /etc/X11/xorg.conf.d/ with the following.
# Section "ServerFlags"
    # Option "DontZap" "false"
# EndSection

# Section "InputClass"
    # Identifier      "Keyboard Defaults"
    # MatchIsKeyboard "yes"
    # Option          "XkbOptions" "terminate:ctrl_alt_bksp"
# EndSection
# ----------------------------------------

# ----------------------------------------
# redshift
# ----------------------------------------
# -37.793342:175.134606 10 harihari lat, long
# redshift -l -37.793342:175.134606 -t 6500:4000 -g 0.8 -m randr -v
# PLACE IN sudo nvim /etc/lightdm/Xsession

# ----------------------------------------
# RESILIO SYNC
# ----------------------------------------
# https://wiki.archlinux.org/title/Resilio_Sync
# mkdir ~/build
# git clone https://aur.archlinux.org/rslsync.git
# cd rslsync
# less PKBUILD # TO MAKE SURE YOURE HAPPY
# mkpkg -sirc
# sudo systemctl enable resilio-sync
# sudo systemctl start resilio-sync
# LOGIN in http://localhost:8888 and set up username and password
# sudo usermod -aG albert rslsync && \
# sudo usermod -aG rslsync albert && \
# sudo chmod g+rx ~
# sudo chmod g+rw ~/GBox
# sudo chmod g+rw ~/resilio-sync



