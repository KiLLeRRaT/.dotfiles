#Requires -RunAsAdministrator

# Write-Host Set PowerShell Execution Policy
# Write-Host ----------------------------------------
# Set-ExecutionPolicy Unrestricted


Write-Host Configuring NVM
Write-Host ----------------------------------------
winget install --id=CoreyButler.NVMforWindows  -e
nvm install lts
nvm use lts


Write-Host Configuring WSL
wsl --install
wsl --install -d Ubuntu-24.04


Write-Host Install Applications
Write-Host ----------------------------------------
winget install BurntSushi.ripgrep.MSVCripgrep # https://github.com/BurntSushi/ripgrep
winget install sharkdp.fd # https://github.com/sharkdp/fd
# choco install sudo # ALLOWS USING sudo IN POWERSHELL!
# choco install win32yank # Neovim clipboard support in WSL, FROM: https://stackoverflow.com/a/67229362/182888

Write-Host Configuring Neovim
Write-Host ----------------------------------------
New-Item -ItemType Junction -Force `
	-Path "$home\AppData\Local\nvim" `
	-Target "$home\.dotfiles\nvim-lua\.config\nvim"


Write-Host Configuring Oh My Posh
Write-Host ----------------------------------------
winget install JanDeDobbeleer.OhMyPosh -s winget
New-Item -ItemType Junction -Force -Path "$home\.omp" -Target "$home\.dotfiles\oh-my-posh\.omp"


Write-Host Configuring PowerShell
Write-Host ----------------------------------------
New-Item -ItemType HardLink -Force `
	-Path "$home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" `
	-Target "$home\.dotfiles\PowerShell\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"


Write-Host Install NerdFont
Write-Host ----------------------------------------
# Make sure to install the nerdfont for all users
# https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip


Write-Host Install Windows Terminal, and configure
Write-Host ----------------------------------------
Move-Item -Force "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.old"
New-Item -ItemType HardLink -Force `
	-Path "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
	-Target "$home\.dotfiles\windows-terminal\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"


