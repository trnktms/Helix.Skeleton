Param(
    [Parameter(Mandatory = $true)] [string]$subProjectName,
    [Parameter(Mandatory = $false)] [string]$configPath,
    [Parameter(Mandatory = $false)] [string]$templatePath)

. ".\helpers\config-helpers.ps1"
. ".\helpers\file-helpers.ps1"
. ".\helpers\log-helpers.ps1"

# settings
$sk_projectName = "[projectName]"
$sk_subProjectName = "[subProjectName]"
$sk_guid = "[[guid]]"
$sk_subProjectGuid_formatB = "[subProjectGuidFormatB]"
$sk_subProjectGuid_formatD = "[subProjectGuidFormatD]"

$root = Split-Path -Parent $PSScriptRoot
$templatesDir = Join-Path -Path $root -ChildPath "sk-templates"
$queueDir = Join-Path -Path $root -ChildPath "sk-queue"
$templatesNewProjectDir = Join-Path -Path $templatesDir -ChildPath "new-project"
$configsDir = Join-Path -Path $root -ChildPath "sk-configs"
$targetDir = Join-Path -Path $root -ChildPath "target"

if ([string]::IsNullOrEmpty($configPath)) {
    $configPath = Join-Path $configsDir -ChildPath "default.9.0.171219.config.json"
}

if ([string]::IsNullOrEmpty($templatePath)) {
    $templatePath = Join-Path -Path $templatesInitDir -ChildPath "default"
}

# deserialiaze JSON config
$config = (Get-Content $configPath) -join "`n" | ConvertFrom-Json

# files
$files = Get-ChildItem -Path $queueDir -File -Recurse -Exclude *.dll, *.pdb, *.xml
$dirs = Get-ChildItem -Path $queueDir -Directory -Recurse

# logo
Logo

# copy to queue
Info("Copy to queue...")
Get-ChildItem -Path $templatePath | Copy-Item -Destination $queueDir -Recurse

# replace content in files
Info("Setup content in files...")
ReplaceContent $files $sk_projectName $config.projectName

IterateOnObjectProperties $config $files

# rename files
Info("Rename files...")
RenameFiles $files $config.projectName $sk_projectName

# rename dirs
Info("Rename directories...")
RenameDirs $dirs $config.projectName $sk_projectName

# copy to target
Info("Copy to target...")
Get-ChildItem -Path $queueDir | Copy-Item -Destination $targetDir -Recurse

# clean up queue
Info("Clean up queue...")
Get-ChildItem -Path $queueDir | Remove-Item -Recurse

InfoDark("DONE!")