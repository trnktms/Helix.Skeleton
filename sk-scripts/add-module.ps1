using module ".\helpers\config-helper.psm1";
using module ".\helpers\file-helper.psm1";
using module ".\helpers\log-helper.psm1"

Param(
    [Parameter(Mandatory = $true)] [string]$moduleName,
    [Parameter(Mandatory = $true)] [string]$subProjectName,
    [Parameter(Mandatory = $true)] [string]$templateName,
    [Parameter(Mandatory = $false)] [string]$targetPath,
    [Parameter(Mandatory = $false)] [string]$configPath,
    [Parameter(Mandatory = $false)] [string]$templatePath)

. ".\settings\settings.ps1";

if ([string]::IsNullOrEmpty($targetPath)) {
    $targetPath = $defaultTargetDir;
}

if ([string]::IsNullOrEmpty($configPath)) {
    $configPath = Join-Path $configsDir -ChildPath "default.9.0.180604.config.json";
}

if ([string]::IsNullOrEmpty($templatePath)) {
    $templatePath = Join-Path -Path $templatesAddModuleDir -ChildPath "default";
    $templatePath = Join-Path -Path $templatePath -ChildPath $templateName;
}

# deserialiaze JSON config
$config = (Get-Content $configPath) -join "`n" | ConvertFrom-Json

# logo
[LogHelper]::Logo();

# copy to queue
[LogHelper]::Info("Copy to queue...");
Get-ChildItem -Path $templatePath | Copy-Item -Destination $queueDir -Recurse;

# files
$files = Get-ChildItem -Path $queueDir -File -Recurse -Exclude *.dll, *.pdb, *.xml;

# replace content in files
[LogHelper]::Info("Setup content in files...");
[FileHelper]::ReplaceContent($files, $sk_projectName, $config.projectName, $null);
[FileHelper]::ReplaceContent($files, $sk_subProjectName, $subProjectName, $null);
[FileHelper]::ReplaceContent($files, $sk_moduleName, $moduleName, $null);

[ConfigHelper]::IterateOnObjectProperties($config, $files);

# rename files
[LogHelper]::Info("Rename files...");
[FileHelper]::RenameFiles($files, $config.projectName, $sk_projectName);

$files = Get-ChildItem -Path $queueDir -File -Recurse -Exclude *.dll, *.pdb, *.xml;
[FileHelper]::RenameFiles($files, $subProjectName, $sk_subProjectName);

$files = Get-ChildItem -Path $queueDir -File -Recurse -Exclude *.dll, *.pdb, *.xml;
[FileHelper]::RenameFiles($files, $moduleName, $sk_moduleName);

# folders
$dirs = Get-ChildItem -Path $queueDir -Directory -Recurse;

# rename dirs
[LogHelper]::Info("Rename unicorn directories...");
[FileHelper]::RenameDirs($root, $dirs, $config.projectName, $sk_projectName);

$dirs = Get-ChildItem -Path $queueDir -Directory -Recurse;
[FileHelper]::RenameDirs($root, $dirs, $subProjectName, $sk_subProjectName);

$dirs = Get-ChildItem -Path $queueDir -Directory -Recurse;
[FileHelper]::RenameDirs($root, $dirs, $moduleName, $sk_moduleName);

# copy to target
[LogHelper]::Info("Copy to target...");
Get-ChildItem -Path $queueDir | Copy-Item -Destination $targetPath -Recurse -Force;

# clean up queue
[LogHelper]::Info("Clean up queue...")
Get-ChildItem -Path $queueDir | Remove-Item -Recurse

[LogHelper]::InfoDark("DONE!")