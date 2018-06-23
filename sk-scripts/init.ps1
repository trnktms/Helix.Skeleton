using module ".\helpers\config-helper.psm1";
using module ".\helpers\file-helper.psm1";
using module ".\helpers\log-helper.psm1";

Param(
    [Parameter(Mandatory = $false)] [string]$configPath,
    [Parameter(Mandatory = $false)] [string]$templatePath)

. ".\settings\settings.ps1";

if ([string]::IsNullOrEmpty($configPath)) {
    $configPath = Join-Path $configsDir -ChildPath "default.9.0.180604.config.json";
}

if ([string]::IsNullOrEmpty($templatePath)) {
    $templatePath = Join-Path -Path $templatesInitDir -ChildPath "default";
}

# deserialiaze JSON config
$config = (Get-Content $configPath) -join "`n" | ConvertFrom-Json;

# logo
[LogHelper]::Logo();

# copy to queue
[LogHelper]::Info("Copy to queue...");
Get-ChildItem -Path $templatePath | Copy-Item -Destination $queueDir -Recurse;

# files
$files = Get-ChildItem -Path $queueDir -File -Recurse -Exclude *.dll, *.pdb, *.xml;

# replace in files
[LogHelper]::Info("Setup content in files...");
[FileHelper]::ReplaceContent($files, $sk_projectName, $config.projectName, $null);

[ConfigHelper]::IterateOnObjectProperties($config, $files);

# rename files
[LogHelper]::Info("Rename files...");
[FileHelper]::RenameFiles($files, $config.projectName, $sk_projectName);

# folders
$dirs = Get-ChildItem -Path $queueDir -Directory -Recurse;

# rename dirs
[LogHelper]::Info("Rename unicorn directories...");
[FileHelper]::RenameDirs($root, $dirs, $config.projectName, $sk_projectName);

# copy to target
[LogHelper]::Info("Copy to target...");
Get-ChildItem -Path $queueDir | Copy-Item -Destination $targetDir -Recurse -Force;

# clean up queue
[LogHelper]::Info("Clean up queue...");
Get-ChildItem -Path $queueDir | Remove-Item -Recurse;

[LogHelper]::InfoDark("DONE!");