function ReplaceWithConfigValue($files, $configValue) {
    Info("Setup " + $configValue.placeholder + " with " + $configValue.value + "...")
    ReplaceContent $files $configValue.placeholder $configValue.value $configValue.operation
}

function ReplaceContent($files, $replaceThis, $replaceWith, $operation) {
    foreach ($file in $files) {
        $fileContent = Get-Content -LiteralPath $file.FullName
        if ($fileContent) {
            if ($operation) {
                $fileContent.Replace($replaceThis, $operation.Invoke($replaceWith)) | Set-Content -LiteralPath $file.FullName
            }
            else {
                $fileContent.Replace($replaceThis, $replaceWith) | Set-Content -LiteralPath $file.FullName
            }
        }
    }
}

function RenameFiles($files, $renameWith, $renameThis) {
    foreach ($file in $files) {
        if ($file -and $file.Name.Contains($renameThis)) {
            Rename-Item -LiteralPath $file.FullName -NewName $file.Name.Replace($renameThis, $renameWith)
        }
    }
}

function RenameDirs($dirs, $renameWith, $renameThis) {
    foreach ($dir in $dirs) {
        if ($dir -and $dir.Name.Contains($renameThis)) {
            $path = $dir.FullName

            $parentPath = $dir.Parent.FullName.Clone()
            $relativeParentPath = $parentPath.Replace($root, "")
            if ($relativeParentPath.Contains($renameThis)) {
                $path = Join-Path -Path $root -ChildPath $relativeParentPath.Replace($renameThis, $renameWith)
                $path = Join-Path -Path $path -ChildPath $dir.Name
            }
        
            $replaced = $dir.Name.Replace($renameThis, $renameWith)
            Rename-Item -LiteralPath $path -NewName $replaced
        }
    }
}