$ErrorActionPreference = "Stop"

$release = Invoke-RestMethod -Uri "https://api.github.com/repos/sharkdp/fd/releases/latest"
$version = $release.tag_name
$zipName = "fd-${version}-x86_64-pc-windows-msvc.zip"
$url = "https://github.com/sharkdp/fd/releases/download/${version}/${zipName}"

Write-Host "Downloading fd $version..."
$tempZip = Join-Path $env:TEMP $zipName
Invoke-WebRequest -Uri $url -OutFile $tempZip

Write-Host "Extracting..."
$tempDir = Join-Path $env:TEMP "fd-extract"
if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
Expand-Archive -Path $tempZip -DestinationPath $tempDir

$installDir = "C:\Tools"
if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }

$innerDir = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
Copy-Item -Path "$($innerDir.FullName)\fd.exe" -Destination $installDir -Force

# Add C:\Tools to system PATH if not already present
$sysPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($sysPath -notlike "*$installDir*") {
    Write-Host "Adding $installDir to system PATH..."
    [Environment]::SetEnvironmentVariable("PATH", "$sysPath;$installDir", "Machine")
}

Remove-Item -Force $tempZip
Remove-Item -Recurse -Force $tempDir

Write-Host "Installed fd $version to $installDir"
