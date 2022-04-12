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


Write-Host Configuring Neovim
Write-Host ----------------------------------------
New-Item -ItemType Junction -Force `
	-Path "$home\AppData\Local\nvim" `
	-Target "$home\.dotfiles\nvim\.config\nvim"


Write-Host Configuring Oh My Posh
Write-Host ----------------------------------------
Install-Module oh-my-posh -Scope CurrentUser
Install-Module posh-git -Scope CurrentUser
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:POSH_PATH", "Machine")
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
