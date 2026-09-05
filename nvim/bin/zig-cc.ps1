$filtered = @()
$skip = $false
foreach ($a in $args) {
	if ($skip) { $skip = $false; continue }
	if ($a -eq '-target' -or $a -eq '--target') { $skip = $true; continue }
	if ($a -like '-target=*' -or $a -like '--target=*') { continue }
	$filtered += $a
}
& zig cc @filtered
exit $LASTEXITCODE
