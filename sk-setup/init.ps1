Param([Parameter(Mandatory = $false)] [string]$configPath, [Parameter(Mandatory = $false)] [string]$templatePath)

. ".\helpers\config-helpers.ps1"
. ".\helpers\file-helpers.ps1"
. ".\helpers\log-helpers.ps1"
. ".\settings\settings.ps1"

if ([string]::IsNullOrEmpty($configPath)) {
    $configPath = Join-Path $configsDir -ChildPath "default.9.0.171219.config.json"
}

if ([string]::IsNullOrEmpty($templatePath)) {
    $templatePath = Join-Path -Path $templatesInitDir -ChildPath "default"
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

# replace in files
Info("Setup content in files...")
ReplaceContent $files $sk_projectName $config.projectName

IterateOnObjectProperties $config $files

# rename files
Info("Rename files...")
RenameFiles $files $config.projectName $sk_projectName

# folders
$dirs = Get-ChildItem -Path $queueDir -Directory -Recurse

# rename dirs
Info("Rename unicorn directories...")
RenameDirs $dirs $config.projectName $sk_projectName

# copy to target
Info("Copy to target...")
Get-ChildItem -Path $queueDir | Copy-Item -Destination $targetDir -Recurse -Force

# clean up queue
Info("Clean up queue...")
Get-ChildItem -Path $queueDir | Remove-Item -Recurse

InfoDark("DONE!")