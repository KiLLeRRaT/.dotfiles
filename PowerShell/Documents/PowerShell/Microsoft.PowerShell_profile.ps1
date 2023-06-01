# THIS IS NEEDED FOR GIT TAB COMPLETION
Import-Module posh-git

#Set-PoshPrompt -Theme Paradox
# Set-PoshPrompt -Theme ~/.mytheme.tokyonight.omp.yaml
# Set-PoshPrompt -Theme ~/.omp/themes/tokyonight.omp.yaml
oh-my-posh init pwsh --config ~/.omp/themes/tokyonight.omp.yaml | Invoke-Expression

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# function prompt {
#   $p = Split-Path -leaf -path (Get-Location)
#   "$p> "
# }
# Attempt to allow duplicating a tab with the same directory as original tab
# function prompt {
#   $loc = $($executionContext.SessionState.Path.CurrentLocation);
#   $out = "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
#   $out += "$([char]27)]9;9;`"$loc`"$([char]27)\"
#   return $out
# }

# $Host.UI.RawUI.WindowTitle = "$pwd"


# IDEA FROM: https://devblogs.microsoft.com/scripting/weekend-scripter-customize-powershell-title-and-prompt/
# Function Prompt
# {
# 	$PromptData="$($executionContext.SessionState.Path.CurrentLocation)"
# 	if ($strVal -like 'C:\Projects.Git\*')
# 	{
# 		$PromptData = $string.replace($PromptData, 'C:\Projects.Git\', '')
# 		$host.ui.RawUI.WindowTitle = $PromptData
# 	}
# }



# PSReadLine extension to provide VI keybindings
Set-PSReadlineOption -EditMode vi
# Set-PSReadLineKeyHandler -Key j,k -Function ViCommandMode

# Bash style completion, AWESOME for completion of paths and directories!!!
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory

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

# REMOVE gl, so that we can use gl.bat for git pull instead of Get-Location
Remove-Alias -Force -Name gl
Remove-Alias -Force -Name gp
Remove-Alias -Force -Name gm


Set-Alias -Name gs -Value 'git status'
Set-Alias -Name gf -Value 'git fetch'
Set-Alias -Name gl -Value 'git pull'
Set-Alias -Name gp -Value 'git push'
Set-Alias -Name gpt -Value 'git push --tags'
Set-Alias -Name gP -Value 'git push --force-with-lease'
Set-Alias -Name ga -Value 'git add'
Set-Alias -Name gcam -Value 'git commit -am'
Set-Alias -Name gd -Value 'git diff'
Set-Alias -Name gw -Value 'git diff --word-diff'
Set-Alias -Name gcm -Value 'git commit -m "${_lc#gcm }" #'
Set-Alias -Name glog -Value 'git logo'
Set-Alias -Name gdog -Value 'git dog'
Set-Alias -Name gadog -Value 'git adog'
Set-Alias -Name gb -Value 'git branch'
Set-Alias -Name gba -Value 'git branch --all'
Set-Alias -Name gco -Value 'git checkout'
Set-Alias -Name gm -Value 'git merge'

# LINUX ONLY
# alias gt='git tag | sort -V | tail'




# For zoxide v0.8.0+
Invoke-Expression (& {
		$hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
		(zoxide init --hook $hook powershell | Out-String)
})
