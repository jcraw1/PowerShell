﻿<#
.SYNOPSIS
	list-console-colors.ps1 
.DESCRIPTION
	Lists all console colors
.EXAMPLE
	PS> .\list-console-colors.ps1
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author:        Markus Fleschutz
	Creation Date: 2021-08-27
	License:       CC0
#>

try {
	$Colors = [Enum]::GetValues([ConsoleColor])
	""
	"Name     `tForeground     `tBackground"
	"----     `t----------     `t----------"
	foreach($Color in $Colors) {
		write-host -noNewline "$Color     `t"
		write-host -noNewline -foregroundcolor $Color "$Color     `t"
		write-host -noNewline -backgroundcolor $Color "$Color"
		write-host ""
	}
	exit 0
} catch {
	write-error "⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
