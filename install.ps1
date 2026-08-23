# Links this repo's nvim config into place. Run on Windows.
# Uses a directory junction so it works without admin rights / Developer Mode.

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Target = "$env:LOCALAPPDATA\nvim"

if (Test-Path $Target) {
	Write-Host "Backing up existing $Target to $Target.bak"
	Rename-Item -Path $Target -NewName "nvim.bak"
}

New-Item -ItemType Junction -Path $Target -Target "$DotfilesDir\nvim" | Out-Null
Write-Host "Linked $Target -> $DotfilesDir\nvim"
