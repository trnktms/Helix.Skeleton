Param(
    [Parameter(Mandatory = $true)] [string]$subProjectName,
    [Parameter(Mandatory = $true)] [string]$templateName,
    [Parameter(Mandatory = $false)] [string]$configPath,
    [Parameter(Mandatory = $false)] [string]$templatePath)

. ".\helpers\config-helpers.ps1"
. ".\helpers\file-helpers.ps1"
. ".\helpers\log-helpers.ps1"
. ".\settings\settings.ps1"

if ([string]::IsNullOrEmpty($configPath)) {
    $configPath = Join-Path $configsDir -ChildPath "default.9.0.171219.config.json"
}

if ([string]::IsNullOrEmpty($templatePath)) {
    $templatePath = Join-Path -Path $templatesNewProjectDir -ChildPath "default"
    $templatePath = Join-Path -Path $templatePath -ChildPath $templateName
}

# deserialiaze JSON config
$config = (Get-Content $configPath) -join "`n" | ConvertFrom-Json

# logo
Logo

# copy to queue
Info("Copy to queue...")
Get-ChildItem -Path $templatePath | Copy-Item -Destination $queueDir -Recurse

# files
$files = Get-ChildItem -Path $queueDir -File -Recurse -Exclude *.dll, *.pdb, *.xml

# replace content in files
Info("Setup content in files...")
ReplaceContent $files $sk_projectName $config.projectName
ReplaceContent $files $sk_subProjectName $subProjectName

IterateOnObjectProperties $config $files

# rename files
Info("Rename files...")
RenameFiles $files $config.projectName $sk_projectName

$files = Get-ChildItem -Path $queueDir -File -Recurse -Exclude *.dll, *.pdb, *.xml
RenameFiles $files $subProjectName $sk_subProjectName

# folders
$dirs = Get-ChildItem -Path $queueDir -Directory -Recurse

# rename dirs
Info("Rename directories...")
RenameDirs $dirs $config.projectName $sk_projectName

$dirs = Get-ChildItem -Path $queueDir -Directory -Recurse
RenameDirs $dirs $subProjectName $sk_subProjectName

# copy to target
Info("Copy to target...")
Get-ChildItem -Path $queueDir | Copy-Item -Destination $targetDir -Recurse -Force

# clean up queue
Info("Clean up queue...")
Get-ChildItem -Path $queueDir | Remove-Item -Recurse

InfoDark("DONE!")