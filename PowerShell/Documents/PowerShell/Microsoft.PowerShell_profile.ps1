Import-Module posh-git
#Set-PoshPrompt -Theme Paradox
# Set-PoshPrompt -Theme ~/.mytheme.tokyonight.omp.yaml
Set-PoshPrompt -Theme ~/.omp/themes/tokyonight.omp.yaml

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# function prompt {
#   $p = Split-Path -leaf -path (Get-Location)
#   "$p> "
# }

# $Host.UI.RawUI.WindowTitle = "$pwd"

# PSReadLine extension to provide VI keybindings
Set-PSReadlineOption -EditMode vi
# Set-PSReadLineKeyHandler -Key j,k -Function ViCommandMode

# FROM: https://github.com/PowerShell/PSReadLine/issues/759#issuecomment-518363364
# Set-PSReadLineKeyHandler -Chord 'j' -ScriptBlock {
# 	if ([Microsoft.PowerShell.PSConsoleReadLine]::InViInsertMode()) {
# 		$key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
# 		if ($key.Character -eq 'k') {
# 			[Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
# 		}
# 		else {
# 			[Microsoft.Powershell.PSConsoleReadLine]::Insert('j')
# 			[Microsoft.Powershell.PSConsoleReadLine]::Insert($key.Character)
# 		}
# 	}
# }

