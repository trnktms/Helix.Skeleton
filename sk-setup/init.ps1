Param([Parameter(Mandatory = $false)] [string]$configPath)

. ".\helpers\config-helpers.ps1"
. ".\helpers\file-helpers.ps1"
. ".\helpers\log-helpers.ps1"

# settings
$sk_projectName = "[projectName]"
$root = Split-Path -Parent $PSScriptRoot
$templateDir = Join-Path -Path $root -ChildPath "sk-template"
$configsDir = Join-Path -Path $root -ChildPath "sk-configs"
$targetDir = Join-Path -Path $root -ChildPath "target"

if ([string]::IsNullOrEmpty($configPath)) {
    $configPath = Join-Path $configsDir -ChildPath "default.9.0.171219.config.json";
}

# deserialiaze JSON config
$config = (Get-Content $configPath) -join "`n" | ConvertFrom-Json

#copy to target
Info("Copy to target...")
Get-ChildItem -Path $templateDir | Copy-Item -Destination $targetDir -Recurse

$unicornDir = Join-Path -Path $targetDir -ChildPath "unicorn"
$srcDir = Join-Path -Path $targetDir -ChildPath "src"
$buildDir = Join-Path -Path $targetDir -ChildPath "build"

# files
$unicornFiles = Get-ChildItem -Path $unicornDir -File -Recurse -Exclude *.dll, *.pdb, *.xml
$srcFiles = Get-ChildItem -Path $srcDir -File -Recurse -Exclude *.dll, *.pdb, *.xml
$packageFiles = Get-ChildItem -Path $srcDir -File -Recurse -Include packages.config, *.csproj, SitecoreTemplates.tt
$buildFiles = Get-ChildItem -Path $buildDir -File -Recurse -Exclude *.dll, *.pdb, *.xml

# logo
Logo

# replace in files
Info("Setup unicorn files...")
ReplaceContent $unicornFiles $sk_projectName $config.projectName
Info("Setup src files...")
ReplaceContent $srcFiles $sk_projectName $config.projectName
Info("Setup script files...")
ReplaceContent $buildFiles $sk_projectName $config.projectName

IterateOnObjectProperties $config $packageFiles

# rename files
Info("Rename unicorn files...")
RenameFiles $unicornFiles $config.projectName $sk_projectName
Info("Rename src files...")
RenameFiles $srcFiles $config.projectName $sk_projectName
Info("Rename script files...")
RenameFiles $buildFiles $config.projectName $sk_projectName

# folders
$unicornDirs = Get-ChildItem -Path $unicornDir -Directory -Recurse
$srcDirs = Get-ChildItem -Path $srcDir -Directory -Recurse

# rename dirs
Info("Rename unicorn directories...")
RenameDirs $unicornDirs $config.projectName $sk_projectName
Info("Rename src directories...")
RenameDirs $srcDirs $config.projectName $sk_projectName

InfoDark("DONE!")