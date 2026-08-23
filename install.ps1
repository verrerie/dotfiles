# Links this repo's configs into place. Run on Windows.
# Uses directory junctions so it works without admin rights / Developer Mode.

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Link-Config($Name, $Target) {
	if (Test-Path $Target) {
		Write-Host "Backing up existing $Target to $Target.bak"
		Rename-Item -Path $Target -NewName "$(Split-Path -Leaf $Target).bak"
	}
	New-Item -ItemType Junction -Path $Target -Target "$DotfilesDir\$Name" | Out-Null
	Write-Host "Linked $Target -> $DotfilesDir\$Name"
}

Link-Config "nvim" "$env:LOCALAPPDATA\nvim"

New-Item -ItemType Directory -Force -Path "$env:APPDATA\yazi" | Out-Null
Link-Config "yazi" "$env:APPDATA\yazi\config"
