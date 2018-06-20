using module ".\log-helper.psm1";

class FileHelper {
    static ReplaceWithConfigValue($files, $configValue) {
        [LogHelper]::Info("Setup " + $configValue.placeholder + " with " + $configValue.value + "...");
        [FileHelper]::ReplaceContent($files, $configValue.placeholder, $configValue.value, $configValue.operation);
    }
    
    static ReplaceContent($files, $replaceThis, $replaceWith, $operation) {
        $realReplaceWith = "";
        if ($operation) {
            $realReplaceWith = $operation.Invoke($replaceWith);
        }
        else {
            $realReplaceWith = $replaceWith;
        }
        foreach ($file in $files) {
            $fileContent = Get-Content -LiteralPath $file.FullName;
            if ($fileContent) {
                $fileContent.Replace($replaceThis, $realReplaceWith) | Set-Content -LiteralPath $file.FullName;
            }
        }
    }
    
    static RenameFiles($files, $renameWith, $renameThis) {
        foreach ($file in $files) {
            if ($file -and $file.Name.Contains($renameThis)) {
                Rename-Item -LiteralPath $file.FullName -NewName $file.Name.Replace($renameThis, $renameWith);
            }
        }
    }
    
    static RenameDirs($root, $dirs, $renameWith, $renameThis) {
        foreach ($dir in $dirs) {
            if ($dir -and $dir.Name.Contains($renameThis)) {
                $path = $dir.FullName;
    
                $parentPath = $dir.Parent.FullName.Clone();
                $relativeParentPath = $parentPath.Replace($root, "");
                if ($relativeParentPath.Contains($renameThis)) {
                    $path = Join-Path -Path $root -ChildPath $relativeParentPath.Replace($renameThis, $renameWith);
                    $path = Join-Path -Path $path -ChildPath $dir.Name;
                }
            
                $replaced = $dir.Name.Replace($renameThis, $renameWith);
                Rename-Item -LiteralPath $path -NewName $replaced;
            }
        }
    }
}