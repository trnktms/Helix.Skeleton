$binDir = "\bin"
$objDir = "\obj"

function ReplaceWithConfigValue($files, $configValue) {
    Info("Setup " + $configValue.placeholder + " with " + $configValue.value + "...")
    ReplaceContent $files $configValue.placeholder $configValue.value
}

function ReplaceContent($files, $replaceThis, $replaceWith) {
    foreach ($file in $files) {
        $fileContent = Get-Content -LiteralPath $file.FullName
        if ($fileContent -and -not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir))) {
            Status($file.FullName)
            $fileContent.Replace($replaceThis, $replaceWith) | Set-Content -LiteralPath $file.FullName
        }
    }
}

function RenameFiles($files, $renameWith, $renameThis) {
    foreach ($file in $files) {
        if ($file -and $file.Name.Contains($renameThis) -and (-not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir)))) {         
            Status($file.FullName)
            Rename-Item -LiteralPath $file.FullName -NewName $file.Name.Replace($renameThis, $renameWith)
        }
    }
}

function RenameDirs($dirs, $renameWith, $renameThis) {
    foreach ($dir in $dirs) {
        if ($dir -and $dir.Name.Contains($renameThis) -and (-not ($dir.FullName.Contains($binDir) -or $dir.FullName.Contains($objDir)))) {
            $path = $dir.FullName

            $parentPath = $dir.Parent.FullName.Clone()
            $relativeParentPath = $parentPath.Replace($root, "")
            if ($relativeParentPath.Contains($renameThis)) {
                $path = Join-Path -Path $root -ChildPath $relativeParentPath.Replace($renameThis, $renameWith)
                $path = Join-Path -Path $path -ChildPath $dir.Name
            }
        
            $replaced = $dir.Name.Replace($renameThis, $renameWith)
            Status($path)
            Rename-Item -LiteralPath $path -NewName $replaced
        }
    }
}