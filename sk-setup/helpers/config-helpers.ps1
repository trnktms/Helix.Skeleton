# public methods
function IterateOnObjectProperties ($object, $files) {
    $object.PSObject.Properties | ForEach-Object {
        $subProperties = $_.Value.PSObject.Properties  | Where-Object { $_.MemberType -eq "NoteProperty" }
        $parentPropertyName = $_.Name
        if (($subProperties.Count -gt 0) -and -not (IsGenerationType $parentPropertyName)) {
            $subProperties | ForEach-Object {
                ReplaceWithConfigValue $files (GetConfigValue $object $parentPropertyName $_.Name)
            }
        }
        else {
            ReplaceWithConfigValue $files (GetConfigValue $object $parentPropertyName)
        }
    }
}

# private methods
function GetConfigValue ($object, $mainProperty, $subProperty) {
    # static generation
    if (IsStaticGenerationType $mainProperty) {
        return GenerateStaticValue $object $mainProperty $subProperty
    }

    # unique generation
    if (IsUniqueGenerationType $mainProperty) {
        return GenerateUniqueValue $object $mainProperty $subProperty
    }

    # simple value from config
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

function IsGenerationType ($mainProperty) {
    return (IsStaticGenerationType $mainProperty) -or (IsUniqueGenerationType $mainProperty)
}

function IsUniqueGenerationType ($mainProperty) {
    return $mainProperty.StartsWith("[") -and $mainProperty.EndsWith("]")
}

function IsStaticGenerationType ($mainProperty) {
    return $mainProperty.StartsWith("[[") -and $mainProperty.EndsWith("]]")
}

function GenerateUniqueValue ($object, $mainProperty, $subProperty) {
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

function GenerateStaticValue ($object, $mainProperty, $subProperty) {
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