using module ".\file-helper.psm1";

class ConfigHelper {
    static IterateOnObjectProperties ($object, $files) {
        $object.PSObject.Properties | ForEach-Object {
            $subProperties = $_.Value.PSObject.Properties  | Where-Object { $_.MemberType -eq "NoteProperty" };
            $parentPropertyName = $_.Name;
            if (($subProperties.Count -gt 0) -and -not ([ConfigHelper]::IsGenerationType($parentPropertyName))) {
                $subProperties | ForEach-Object {
                    [FileHelper]::ReplaceWithConfigValue($files, ([ConfigHelper]::GetConfigValue($object, $parentPropertyName, $_.Name)));
                }
            }
            else {
                [FileHelper]::ReplaceWithConfigValue($files, ([ConfigHelper]::GetConfigValue($object, $parentPropertyName)));
            }
        }
    }

    static [object] GetConfigValue($object, $mainProperty, $subProperty) {
        return @{
            value       = $object.$mainProperty.$subProperty
            operation   = $null
            placeholder = "[" + $mainProperty + "." + $subProperty + "]"
        };
    }

    static [object] GetConfigValue($object, $mainProperty) {
        if ([ConfigHelper]::IsStaticGenerationType($mainProperty)) {
            return [ConfigHelper]::GenerateStaticValue($object, $mainProperty);
        }

        if ([ConfigHelper]::IsUniqueGenerationType($mainProperty)) {
            return [ConfigHelper]::GenerateUniqueValue($object, $mainProperty);
        }

        return @{
            value       = $object.$mainProperty
            operation   = $null
            placeholder = "[" + $mainProperty + "]"
        };
    }

    static [bool] IsGenerationType($mainProperty) {
        return ([ConfigHelper]::IsStaticGenerationType($mainProperty)) -or ([ConfigHelper]::IsUniqueGenerationType($mainProperty));
    }

    static [bool] IsUniqueGenerationType($mainProperty) {
        return $mainProperty.StartsWith("[") -and $mainProperty.EndsWith("]");
    }

    static [bool] IsStaticGenerationType($mainProperty) {
        return $mainProperty.StartsWith("[[") -and $mainProperty.EndsWith("]]");
    }

    static [object] GenerateUniqueValue($object, $mainProperty) {
        switch ($object.$mainProperty.type) {
            "guid" {
                return @{
                    value       = $object.$mainProperty.format
                    operation   = { param($format) return [Guid]::NewGuid().ToString($format); }
                    placeholder = "[" + $mainProperty + "]"
                };
            }
        }

        return null;
    }

    static [object] GenerateStaticValue($object, $mainProperty) {
        switch ($object.$mainProperty.type) {
            "guid" {
                return @{
                    value       = [Guid]::NewGuid().ToString($object.$mainProperty.format)
                    operation   = $null
                    placeholder = "[" + $mainProperty + "]"
                };
            }
        }

        return null;
    } 
}