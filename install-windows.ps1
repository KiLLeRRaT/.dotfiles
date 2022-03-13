#Requires -RunAsAdministrator

# New-Item -ItemType HardLink -Path "~\.dotfiles\nvim\.config\nvim\init.vim" -Target "~\AppData\Local\nvim\init.vim"
# New-Item -ItemType HardLink -Force -Path "$home\AppData\Local\nvim\init.vim" -Target "$home\.dotfiles\nvim\.config\nvim\init.vim"
New-Item -ItemType Junction -Force -Path "$home\AppData\Local\nvim" -Target "$home\.dotfiles\nvim\.config\nvim"

