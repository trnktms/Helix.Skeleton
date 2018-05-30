function IterateOnObjectProperties ($object) {
    $object.PSObject.Properties | ForEach-Object {
        $subProperties = $_.Value.PSObject.Properties  | Where-Object { $_.MemberType -eq "NoteProperty" }
        $parentPropertyName = $_.Name
        if ($subProperties.Count -gt 0) {
            $subProperties | ForEach-Object {
                ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue $parentPropertyName $_.Name)
            }
        }
        else {
            ReplaceWithConfigValue $packageFiles -configValue (GetConfigValue $parentPropertyName)
        }
    }
}

function GetConfigValue ($mainProperty, $subProperty) {
    if ([string]::IsNullOrEmpty($subProperty)) {
        return @{
            value = $config.$mainProperty;
            placeholder = "[" + $mainProperty + "]"
        };
    }
    else {
        return @{
            value = $config.$mainProperty.$subProperty;
            placeholder = "[" + $mainProperty + "." + $subProperty + "]"
        };
    }
}