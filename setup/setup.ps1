Param([Parameter(Mandatory = $true)] [string]$ProjectName)

function Replace($files) {
    foreach ($file in $files) {
        $fileContent = Get-Content $file.FullName
        if ($fileContent -and -not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir))) {
            Status($file.FullName)
            $fileContent.Replace($skeletonName, $ProjectName) | Set-Content $file.FullName
        }
    }
}

function RenameFiles($files) {
    foreach ($file in $files) {
        if ($file -and $file.Name.Contains($skeletonName) -and (-not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir)))) {         
            Status($file.FullName)
            Rename-Item -Path $file.FullName  -NewName $file.Name.Replace($skeletonName, $ProjectName)
        }
    }
}

function RenameDirs($dirs) {
    foreach ($dir in $dirs) {
        if ($dir -and $dir.Name.Contains($skeletonName) -and (-not ($dir.FullName.Contains($binDir) -or $dir.FullName.Contains($objDir)))) {
            $path = $dir.FullName

            $parentPath = $dir.Parent.FullName.Clone()
            $relativeParentPath = $parentPath.Replace($root, "")
            if ($relativeParentPath.Contains($skeletonName)) {
                $path = Join-Path -Path $root -ChildPath $relativeParentPath.Replace($skeletonName, $ProjectName)
                $path = Join-Path -Path $path -ChildPath $dir.Name
            }
        
            $replaced = $dir.Name.Replace($skeletonName, $ProjectName)
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
    Write-Host("==============") -Foreground $color
    Write-Host("HELIX SKELETON") -Foreground $color
    Write-Host("==============") -Foreground $color
}

# settings
$skeletonName = "TestProject"
$binDir = "\bin"
$objDir = "\obj"
$root = Split-Path -Parent $PSScriptRoot
$unicornDir = Join-Path -Path $root -ChildPath "unicorn"
$srcDir = Join-Path -Path $root -ChildPath "src"

# files
$unicornFiles = Get-ChildItem -Path $unicornDir -File -Recurse -Exclude *.dll,*.pdb,*.xml
$srcFiles = Get-ChildItem -Path $srcDir -File -Recurse -Exclude *.dll,*.pdb,*.xml

# logo
Logo

# replace in files
Info("Setup unicorn files...")
Replace($unicornFiles)
Info("Setup src files...")
Replace($srcFiles)

# rename files
Info("Rename unicorn files...")
RenameFiles($unicornFiles)
Info("Rename src files...")
RenameFiles($srcFiles)

# folders
$unicornDirs = Get-ChildItem -Path $unicornDir -Directory -Recurse
$srcDirs = Get-ChildItem -Path $srcDir -Directory -Recurse

# rename dirs
Info("Rename unicorn directories...")
RenameDirs($unicornDirs)
Info("Rename src directories ...")
RenameDirs($srcDirs)