﻿<#
.SYNOPSIS
	Pulls Git repository updates 
.DESCRIPTION
	This PowerShell script pulls updates for a local Git repository (including submodules).
.PARAMETER RepoDir
	Specifies the path to the Git repository
.EXAMPLE
	PS> ./pull-repo 
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([string]$RepoDir = "$PWD")

try {
	$StopWatch = [system.diagnostics.stopwatch]::startNew()

	"⏳ Step 1/4 - Searching for Git executable..."
	& git --version
	if ($lastExitCode -ne "0") { throw "Can't execute 'git' - make sure Git is installed and available" }

	"⏳ Step 2/4 - Checking Git repository..."
	if (-not(Test-Path "$RepoDir" -pathType container)) { throw "Can't access folder: $RepoDir" }

	$Result = (git -C "$RepoDir" status)
	if ("$Result" -match "HEAD detached at ") { throw "Not on a branch, so nothing to pull (in detached HEAD state)" }

	"⏳ Step 3/4 - Pulling updates..."
	& git -C "$RepoDir" pull --recurse-submodules --jobs=4
	if ($lastExitCode -ne "0") { throw "'git pull' failed with exit code $lastExitCode" }

	"⏳ Step 4/4 - Updating submodules... "
	& git -C "$RepoDir" submodule update --init --recursive
	if ($lastExitCode -ne "0") { throw "'git submodule update' failed with exit code $lastExitCode" }

	$RepoDirName = (Get-Item "$RepoDir").Name
	[int]$Elapsed = $StopWatch.Elapsed.TotalSeconds
	"✔️ pulled updates for 📂$RepoDirName repo in $Elapsed sec"
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}