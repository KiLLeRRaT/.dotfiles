#!/bin/sh



apk add git curl stow neovim 


#echo Clone dotfiles
#git clone https://github.com/KiLLeRRaT/.dotfiles.git

echo Running stow
STOW_FOLDERS=nvim
cd ~/.dotfiles
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo Running stow $folder in $PWD
    stow -D $folder
    stow $folder
done

# NOW INSTALL THE VIM PLUGINS
nvim --headless +PlugInstall +q

