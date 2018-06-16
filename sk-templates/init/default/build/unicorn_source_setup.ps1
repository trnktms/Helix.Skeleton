# Author: Zsolt Keller

$fileName = "[projectName].Sitecore.config"
$configPath = "sitecore\Website\App_Config\Include"
$sourceFilePath =  Join-Path $PSScriptRoot -ChildPath $filename

$projectDir = Split-Path -Parent $PSScriptRoot
$configDir = Join-Path -Path $projectDir -ChildPath $configPath
$destinationFilePath = Join-Path $configDir -ChildPath $fileName

if(!(Test-Path $sourceFilePath)){
    Write-Error "The file does not exist under the $sourceFilePath path"
    exit
}

if(!(Test-Path $configDir)){
    Write-Error "The $configDir config folder does not exist"
    exit
}


# Copying the file to the \sitecore\Website\App_Config\Include folder
Copy-Item $sourceFilePath $configDir

if(!(Test-Path $destinationFilePath)){
    Write-Error "The $destinationFilePath config file does not exist"
    exit
}

# Replacing the file content with the proper source
(Get-Content $destinationFilePath).replace('[folderPath]', $projectDir) | Set-Content $destinationFilePath
