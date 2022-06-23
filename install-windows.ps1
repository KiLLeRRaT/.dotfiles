#Requires -RunAsAdministrator

# Write-Host Set PowerShell Execution Policy
# Write-Host ----------------------------------------
# Set-ExecutionPolicy Unrestricted


Write-Host Configuring NVM
Write-Host ----------------------------------------
$installPath = "C:\Users\Albert\AppData\Roaming\nvm"
if (-not (Test-Path -Path $installPath))
{
	$nvmUrl =  "https://github.com/coreybutler/nvm-windows/releases/latest/download/nvm-setup.zip"
	$extractPath = "C:\Temp\nvm\"
	$downloadZipFile = $extractPath + $(Split-Path -Path $nvmUrl -Leaf)
	mkdir $extractPath
	Invoke-WebRequest -Uri $nvmUrl -OutFile $downloadZipFile
	$extractShell = New-Object -ComObject Shell.Application
	$extractFiles = $extractShell.Namespace($downloadZipFile).Items()
	$extractShell.NameSpace($extractPath).CopyHere($extractFiles)
	pushd $extractPath
	Start-Process .\nvm-setup.exe -Wait
	popd
	Read-Host -Prompt "Setup done, now close the command window, and run this script again in a new elevated window. Press any key to continue"
	Exit
}
else
{
	Write-Host Detected that NVM is already installed, so now using it to install NodeJS LTS
	pushd $installPath
	.\nvm.exe install lts
	.\nvm.exe use lts
	popd
}


Write-Host Configuring WSL
wsl --install -d Ubuntu-20.04


Write-Host Install Chocolatey
Write-Host ----------------------------------------
Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


Write-Host Install ripgrep and fd
Write-Host ----------------------------------------
# https://github.com/sharkdp/fd
# https://github.com/BurntSushi/ripgrep
choco install ripgrep
choco install fd

Write-Host Install win32yank for Neovim clipboard support in WSL
Write-Host ----------------------------------------
# https://stackoverflow.com/a/67229362/182888
choco install win32yank

Write-Host Configuring Neovim
Write-Host ----------------------------------------
New-Item -ItemType Junction -Force `
	-Path "$home\AppData\Local\nvim" `
	-Target "$home\.dotfiles\nvim\.config\nvim"


Write-Host Configuring Oh My Posh
Write-Host ----------------------------------------
# Install-Module oh-my-posh -Scope CurrentUser
# Install-Module posh-git -Scope CurrentUser
# [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:POSH_PATH", "Machine")

# winget install oh-my-posh
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
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


Write-Host Registry Tweaks
Write-Host ----------------------------------------

## Show hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden 1

## Show file extensions for known file types
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt 0

## Never Combine taskbar buttons when the taskbar is full
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarGlomLevel -Value 2

# Taskbar small icons
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarSmallIcons -Value 1




