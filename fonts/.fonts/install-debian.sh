#!/bin/bash

# FROM: https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0#file-instructions-md

# 1.) Download a [Nerd Font](http://nerdfonts.com/)
# sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
# wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip -O .fonts/

# 2.) Unzip and copy to `~/.fonts`
# unzip .fonts/CascadiaCode.zip

# 3.) Run the command `fc-cache -fv` to manually rebuild the font cache

fc-cache -fv
