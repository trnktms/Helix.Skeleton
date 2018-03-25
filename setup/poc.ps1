$configPath = Join-Path $PSScriptRoot -ChildPath "default.config.json"
$config = (Get-Content $configPath) -join "`n" | ConvertFrom-Json

function GetConfigValue ($mainProperty, $subProperty) {
    if ([string]::IsNullOrEmpty($subProperty)) {
        return @{
            value = $config.$mainProperty;
            placeholder = "[" + $mainProperty + "]";
        };
    } else {
        return @{
            value = $config.$mainProperty.$subProperty;
            placeholder = "[" + $mainProperty + "." + $subProperty + "]";
        };
    }
}

$test = GetConfigValue "targetFramework";
Write-Host($test.value + $test.placeholder)

$test = GetConfigValue "sitecore" "version";
Write-Host($test.value + $test.placeholder)