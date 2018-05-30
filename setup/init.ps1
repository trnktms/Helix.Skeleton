Param([Parameter(Mandatory = $false)] [string]$configPath)

. ".\helpers\config-helpers.ps1"
. ".\helpers\file-helpers.ps1"
. ".\helpers\log-helpers.ps1"

if ([string]::IsNullOrEmpty($configPath)) {
    $configPath = Join-Path $PSScriptRoot -ChildPath "default.9.0.171219.config.json";
}

$config = (Get-Content $configPath) -join "`n" | ConvertFrom-Json

# settings
$sk_projectName = "[projectName]"

$binDir = "\bin"
$objDir = "\obj"
$root = Split-Path -Parent $PSScriptRoot
$templateDir = Join-Path -Path $root -ChildPath "template"
$targetDir = Join-Path -Path $root -ChildPath "target"
$unicornDir = Join-Path -Path $templateDir -ChildPath "unicorn"
$srcDir = Join-Path -Path $templateDir -ChildPath "src"
$buildDir = Join-Path -Path $templateDir -ChildPath "build"

# files
$unicornFiles = Get-ChildItem -Path $unicornDir -File -Recurse -Exclude *.dll, *.pdb, *.xml
$srcFiles = Get-ChildItem -Path $srcDir -File -Recurse -Exclude *.dll, *.pdb, *.xml
$packageFiles = Get-ChildItem -Path $srcDir -File -Recurse -Include packages.config, *.csproj, SitecoreTemplates.tt
$buildFiles = Get-ChildItem -Path $buildDir -File -Recurse -Exclude *.dll, *.pdb, *.xml

# logo
Logo

# replace in files
Info("Setup unicorn files...")
Replace $unicornFiles $sk_projectName $config.projectName
Info("Setup src files...")
Replace $srcFiles $sk_projectName $config.projectName
Info("Setup script files...")
Replace $buildFiles $sk_projectName $config.projectName

IterateOnObjectProperties $config

# rename files
Info("Rename unicorn files...")
RenameFiles $unicornFiles $config.projectName
Info("Rename src files...")
RenameFiles $srcFiles $config.projectName
Info("Rename script files...")
RenameFiles $buildFiles $config.projectName

# folders
$unicornDirs = Get-ChildItem -Path $unicornDir -Directory -Recurse
$srcDirs = Get-ChildItem -Path $srcDir -Directory -Recurse

# rename dirs
Info("Rename unicorn directories...")
RenameDirs $unicornDirs $config.projectName
Info("Rename src directories...")
RenameDirs $srcDirs $config.projectName

#copy to target
Info("Copy to target...")
Get-ChildItem -Path $templateDir | Copy-Item -Destination $targetDir -Recurse
InfoDark("DONE!")