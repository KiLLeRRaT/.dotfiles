#Requires -RunAsAdministrator

# New-Item -ItemType HardLink -Path "~\.dotfiles\nvim\.config\nvim\init.vim" -Target "~\AppData\Local\nvim\init.vim"
# New-Item -ItemType HardLink -Force -Path "$home\AppData\Local\nvim\init.vim" -Target "$home\.dotfiles\nvim\.config\nvim\init.vim"
New-Item -ItemType Junction -Force -Path "$home\AppData\Local\nvim" -Target "$home\.dotfiles\nvim\.config\nvim"

#TODO:
# - oh-my-posh
New-Item -ItemType Junction -Force -Path "$home\.omp" -Target "$home\.dotfiles\oh-my-posh\.omp"

# - PowerShell
New-Item -ItemType HardLink -Force -Path "$home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$home\.dotfiles\PowerShell\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

