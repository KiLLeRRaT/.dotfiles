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
# WE HAVE TO BUILD XRDP...
pamac build xrdp --no-confirm
pamac install git --no-confirm
pamac install curl --no-confirm
pamac install stow --no-confirm
pamac install neovim --no-confirm
pamac install xclip --no-confirm
pamac install ripgrep --no-confirm
pamac install fd --no-confirm
pamac install alacritty --no-confirm
pamac install timeshift --no-confirm
pamac install tmux --no-confirm
pamac install btop --no-confirm
pamac install unzip --no-confirm

read -k 1 -r "install_app?Install Signal? (y/n) "
echo -e ""
if [[ $install_app =~ ^[Yy]$ ]]
then
	pamac install signal-desktop --no-confirm
fi

read -k 1 -r "install_app?Install Redshift (Night light)? (y/n) "
echo -e ""
if [[ $install_app =~ ^[Yy]$ ]]
then
	pamac install redshift --no-confirm
fi

#pamac install snapd --no-confirm
#systemctl enable --now snapd.socket
#ln -s /var/lib/snapd/snap /snap
#echo -e "Done"


read -k 1 -r "install_brave?Install brave browser? (y/n) "
echo -e ""
if [[ $install_brave =~ ^[Yy]$ ]]
then
	echo -e "\033[32m ----------------------------------------\033[0m"
	echo -e "\033[32m Installing brave browser\033[0m"
	echo -e "\033[32m ----------------------------------------\033[0m"
	pamac install brave-browser --no-confirm
	#snap install brave
	echo -e "Done"
fi


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

