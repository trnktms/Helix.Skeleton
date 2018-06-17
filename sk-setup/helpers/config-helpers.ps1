function IterateOnObjectProperties ($object, $files) {
    $object.PSObject.Properties | ForEach-Object {
        $subProperties = $_.Value.PSObject.Properties  | Where-Object { $_.MemberType -eq "NoteProperty" }
        $parentPropertyName = $_.Name
        if ($subProperties.Count -gt 0) {
            $subProperties | ForEach-Object {
                ReplaceWithConfigValue $files -configValue (GetConfigValue $object $parentPropertyName $_.Name)
            }
        }
        else {
            ReplaceWithConfigValue $files -configValue (GetConfigValue $object $parentPropertyName)
        }
    }
}

function GetConfigValue ($object, $mainProperty, $subProperty) {
    # static generation
    if ($mainProperty.StartsWith("[[") -and $mainProperty.EndsWith("]]")) {
        switch ($object.$mainProperty.type) {
            "guid" {
                return @{
                    value       = [Guid]::NewGuid().ToString($object.$mainProperty.format)
                    placeholder = "[" + $mainProperty + "]"
                }
            }
            Default {
                return;
            }
        }
    }

    # unique generation
    if ($mainProperty.StartsWith("[") -and $mainProperty.EndsWith("]")) {
        switch ($object.$mainProperty.type) {
            "guid" {
                return @{
                    value       = $object.$mainProperty.format
                    operation   = { param($format) return [Guid]::NewGuid().ToString($format); }
                    placeholder = "[" + $mainProperty + "]"
                }
            }
            Default {
                return;
            }
        }
    }

    # static
    if ([string]::IsNullOrEmpty($subProperty)) {
        return @{
            value       = $object.$mainProperty
            placeholder = "[" + $mainProperty + "]"
        };
    }

    return @{
        value       =  $object.$mainProperty.$subProperty
        placeholder = "[" + $mainProperty + "." + $subProperty + "]"
    };
}