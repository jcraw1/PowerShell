#!/bin/powershell
<#
.SYNTAX       ./create-branch.ps1 [<new-branch-name>] [<repo-dir>]
.DESCRIPTION  creates a new branch in the current/given Git repository 
.LINK         https://github.com/fleschutz/PowerShell
.NOTES        Author: Markus Fleschutz / License: CC0
#>

param($NewBranchName = "", $RepoDir = "$PWD")

if ($NewBranchName -eq "") {
	$NewBranchName = read-host "Enter new branch name"
}

try {
	if (-not(test-path "$RepoDir" -pathType container)) { throw "Can't access directory: $RepoDir" }
	set-location "$RepoDir"

	& git --version
	if ($lastExitCode -ne "0") { throw "Can't execute 'git' - make sure Git is installed and available" }

	$Result = (git status)
	if ($lastExitCode -ne "0") { throw "'git status' failed in $RepoDir" }
	if ("$Result" -notmatch "nothing to commit, working tree clean") { throw "Repository is NOT clean: $Result" }

	& git fetch --all --recurse-submodules
	if ($lastExitCode -ne "0") { throw "'git fetch --all --recurse-submodules' failed" }

	& git checkout -b "$NewBranchName"
	if ($lastExitCode -ne "0") { throw "'git checkout -b $NewBranchName' failed" }

	& git push origin "$NewBranchName"
	if ($lastExitCode -ne "0") { throw "'git push origin $NewBranchName' failed" }

	& git submodule update --init --recursive
	if ($lastExitCode -ne "0") { throw "'git submodule update' failed" }

	exit 0
} catch {
	write-error "ERROR: line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}