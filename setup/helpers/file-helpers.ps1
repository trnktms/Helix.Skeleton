function ReplaceWithConfigValue($files, $configValue) {
    Info("Setup " + $configValue.placeholder + " with " + $configValue.value + "...")
    Replace $files $configValue.placeholder $configValue.value
}

function Replace($files, $replaceThis, $replaceWith) {
    foreach ($file in $files) {
        $fileContent = Get-Content -LiteralPath $file.FullName
        if ($fileContent -and -not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir))) {
            Status($file.FullName)
            $fileContent.Replace($replaceThis, $replaceWith) | Set-Content -LiteralPath $file.FullName
        }
    }
}

function RenameFiles($files, $newName) {
    foreach ($file in $files) {
        if ($file -and $file.Name.Contains($sk_projectName) -and (-not ($file.FullName.Contains($binDir) -or $file.FullName.Contains($objDir)))) {         
            Status($file.FullName)
            Rename-Item -LiteralPath $file.FullName -NewName $file.Name.Replace($sk_projectName, $newName)
        }
    }
}

function RenameDirs($dirs, $newName) {
    foreach ($dir in $dirs) {
        if ($dir -and $dir.Name.Contains($sk_projectName) -and (-not ($dir.FullName.Contains($binDir) -or $dir.FullName.Contains($objDir)))) {
            $path = $dir.FullName

            $parentPath = $dir.Parent.FullName.Clone()
            $relativeParentPath = $parentPath.Replace($root, "")
            if ($relativeParentPath.Contains($sk_projectName)) {
                $path = Join-Path -Path $root -ChildPath $relativeParentPath.Replace($sk_projectName, $newName)
                $path = Join-Path -Path $path -ChildPath $dir.Name
            }
        
            $replaced = $dir.Name.Replace($sk_projectName, $newName)
            Status($path)
            Rename-Item -LiteralPath $path -NewName $replaced
        }
    }
}