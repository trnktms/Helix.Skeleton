Param([Parameter(Mandatory = $false)] [string]$configPath)

if ([string]::IsNullOrEmpty($configPath)) {
    $configPath = Join-Path $PSScriptRoot -ChildPath "default.8.2.170614.config.json";
}

$config = (Get-Content $configPath) -join "`n" | ConvertFrom-Json

# operation helpers
function GetConfigValue ($mainProperty, $subProperty) {
    if ([string]::IsNullOrEmpty($subProperty)) {
        return @{
            value       = $config.$mainProperty;
            placeholder = "[" + $mainProperty + "]"
        };
    }
    else {
        return @{
            value       = $config.$mainProperty.$subProperty;
            placeholder = "[" + $mainProperty + "." + $subProperty + "]"
        };
    }
}

function ReplaceWithConfigValue($files, $configValue) {
    Info("Setup " + $configValue.placeholder + " with " + $configValue.value + "...")
    Replace $files $configValue.placeholder $configValue.value
}

function Replace($files, $replaceThis, $replaceWith) {
    foreach ($file in $files) {
        $fileContent = Get-Content $file.FullName
        if ($fileContent -and -not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir))) {
            Status($file.FullName)
            $fileContent.Replace($replaceThis, $replaceWith) | Set-Content $file.FullName
        }
    }
}

function RenameFiles($files) {
    foreach ($file in $files) {
        if ($file -and $file.Name.Contains($sk_projectName) -and (-not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir)))) {         
            Status($file.FullName)
            Rename-Item -Path $file.FullName  -NewName $file.Name.Replace($sk_projectName, $config.projectName)
        }
    }
}

function RenameDirs($dirs) {
    foreach ($dir in $dirs) {
        if ($dir -and $dir.Name.Contains($sk_projectName) -and (-not ($dir.FullName.Contains($binDir) -or $dir.FullName.Contains($objDir)))) {
            $path = $dir.FullName

            $parentPath = $dir.Parent.FullName.Clone()
            $relativeParentPath = $parentPath.Replace($root, "")
            if ($relativeParentPath.Contains($sk_projectName)) {
                $path = Join-Path -Path $root -ChildPath $relativeParentPath.Replace($sk_projectName, $config.projectName)
                $path = Join-Path -Path $path -ChildPath $dir.Name
            }
        
            $replaced = $dir.Name.Replace($sk_projectName, $config.projectName)
            Status($path)
            Rename-Item -Path $path -NewName $replaced
        }
    }
}

# log helpers
function Status($message) {
    Write-Host($message) -Foreground "green"
}

function Info($message) {
    $color = "magenta"
    Write-Host($message) -Foreground $color
    Start-Sleep -Seconds 1
}

function Logo() {
    $color = "darkmagenta"
    Write-Host("   __ ________   _____  __  ______ ________   ______________  _  __")   -Foreground $color
    Write-Host("  / // / __/ /  /  _/ |/_/ / __/ //_/ __/ /  / __/_  __/ __ \/ |/ /")   -Foreground $color
    Write-Host(" / _  / _// /___/ /_>  <  _\ \/ ,< / _// /__/ _/  / / / /_/ /    /")    -Foreground $color 
    Write-Host("/_//_/___/____/___/_/|_| /___/_/|_/___/____/___/ /_/  \____/_/|_/")     -Foreground $color
    Write-Host("")
}

# settings
$sk_projectName = "Helix.Skeleton"

$binDir = "\bin"
$objDir = "\obj"
$root = Split-Path -Parent $PSScriptRoot
$unicornDir = Join-Path -Path $root -ChildPath "unicorn"
$srcDir = Join-Path -Path $root -ChildPath "src"
$buildDir = Join-Path -Path $root -ChildPath "build"

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

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "targetFramework")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "nugetTargetFramework")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "aspNet" "lib")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "aspNet" "mvcVersion")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "aspNet" "webPagesVersion")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "aspNet" "razorVersion")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "sitecore" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "sitecore" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "glassMapper" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "glassMapper" "lib")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "glassMapper" "sitecoreVersion")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "glassMapper" "mvcVersion")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "castle" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "castle" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "rainbow" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "rainbow" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "rainbowCodeGeneration" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "rainbowCodeGeneration" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "microsoftDependencyInjection" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "microsoftDependencyInjection" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "microsoftDependencyInjectionAbstraction" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "microsoftDependencyInjectionAbstraction" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "unicorn" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "unicorn" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "configy" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "configy" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "kamsarWebconsole" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "kamsarWebconsole" "lib")

ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "microCHAP" "version")
ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue "microCHAP" "lib")

# rename files
Info("Rename unicorn files...")
RenameFiles $unicornFiles
Info("Rename src files...")
RenameFiles $srcFiles
Info("Rename script files...")
RenameFiles $buildFiles

# folders
$unicornDirs = Get-ChildItem -Path $unicornDir -Directory -Recurse
$srcDirs = Get-ChildItem -Path $srcDir -Directory -Recurse

# rename dirs
Info("Rename unicorn directories...")
RenameDirs $unicornDirs
Info("Rename src directories ...")
RenameDirs $srcDirs