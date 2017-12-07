Param([Parameter(Mandatory = $true)] [string]$projectName, [Parameter(Mandatory = $true)] [string]$sitecoreVersion, [Parameter(Mandatory = $true)] [string]$glassMapperVersion, [Parameter(Mandatory = $true)] [string]$dotnetVersion)

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
        if ($file -and $file.Name.Contains($sk_name) -and (-not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir)))) {         
            Status($file.FullName)
            Rename-Item -Path $file.FullName  -NewName $file.Name.Replace($sk_name, $projectName)
        }
    }
}

function RenameDirs($dirs) {
    foreach ($dir in $dirs) {
        if ($dir -and $dir.Name.Contains($sk_name) -and (-not ($dir.FullName.Contains($binDir) -or $dir.FullName.Contains($objDir)))) {
            $path = $dir.FullName

            $parentPath = $dir.Parent.FullName.Clone()
            $relativeParentPath = $parentPath.Replace($root, "")
            if ($relativeParentPath.Contains($sk_name)) {
                $path = Join-Path -Path $root -ChildPath $relativeParentPath.Replace($sk_name, $projectName)
                $path = Join-Path -Path $path -ChildPath $dir.Name
            }
        
            $replaced = $dir.Name.Replace($sk_name, $projectName)
            Status($path)
            Rename-Item -Path $path -NewName $replaced
        }
    }
}

function Status($message) {
    Write-Host($message) -Foreground "green"
}

function Info($message) {
    $color = "magenta"
    Write-Host($message) -Foreground $color
    Start-Sleep -Seconds 3
}

function Logo() {
    $color = "darkmagenta"
    Write-Host("   __ ________   _____  __  ______ ________   ______________  _  __") -Foreground $color
    Write-Host("  / // / __/ /  /  _/ |/_/ / __/ //_/ __/ /  / __/_  __/ __ \/ |/ /") -Foreground $color
    Write-Host(" / _  / _// /___/ /_>  <  _\ \/ ,< / _// /__/ _/  / / / /_/ /    /") -Foreground $color 
    Write-Host("/_//_/___/____/___/_/|_| /___/_/|_/___/____/___/ /_/  \____/_/|_/") -Foreground $color
    Write-Host("")
}

# settings
$sk_name = "Helix.Skeleton"
$sk_sitecoreVersion = "[sitecoreVersion]"
$sk_glassMapperVersion = "[glassMapperVersion]"
$sk_dotnetVersion = "[dotnetVersion]"
$binDir = "\bin"
$objDir = "\obj"
$root = Split-Path -Parent $PSScriptRoot
$unicornDir = Join-Path -Path $root -ChildPath "unicorn"
$srcDir = Join-Path -Path $root -ChildPath "src"
$buildDir = Join-Path -Path $root -ChildPath "build"

# files
$unicornFiles = Get-ChildItem -Path $unicornDir -File -Recurse -Exclude *.dll,*.pdb,*.xml
$srcFiles = Get-ChildItem -Path $srcDir -File -Recurse -Exclude *.dll,*.pdb,*.xml
$packageFiles = Get-ChildItem -Path $srcDir -File -Recurse -Include packages.config,*.csproj
$buildFiles = Get-ChildItem -Path $buildDir -File -Recurse -Exclude *.dll,*.pdb,*.xml

# logo
Logo

# replace in files
Info("Setup unicorn files...")
Replace $unicornFiles $sk_name $projectName
Info("Setup src files...")
Replace $srcFiles $sk_name $projectName
Info("Setup script files...")
Replace $buildFiles $sk_name $projectName
Info("Setup Sitecore version...")
Replace $packageFiles $sk_sitecoreVersion $sitecoreVersion
Info("Setup Glass Mapper version...")
Replace $packageFiles  $sk_glassMapperVersion $glassMapperVersion
Info("Setup .NET version...")
Replace $packageFiles  $sk_dotnetVersion $dotnetVersion

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