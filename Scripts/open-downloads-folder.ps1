﻿<#
.SYNOPSIS
	Opens the downloads folder
.DESCRIPTION
	This script starts the File Explorer to show the downloads folder.
.EXAMPLE
	PS> ./open-downloads-folder
.NOTES
	Author: Markus Fleschutz · License: CC0
.LINK
	https://github.com/fleschutz/PowerShell
#>

try {
	$TargetDir = resolve-path "$HOME/Downloads"
	if (-not(test-path "$TargetDir" -pathType container)) {
		throw "Downloads folder at 📂$TargetDir doesn't exist (yet)"
	}
	& "$PSScriptRoot/open-file-explorer.ps1" "$TargetDir"
	exit 0 # success
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}