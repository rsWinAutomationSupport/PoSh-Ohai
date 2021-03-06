$provides = 'ServerFeatures', 'OptionalFeatures'

function Collect-Data {
    $ServerFeatures = New-Object System.Collections.Specialized.OrderedDictionary
    $OptionalFeatures = New-Object System.Collections.Specialized.OrderedDictionary

    $list_ServerFeatures = Get-WmiObject -Class Win32_ServerFeature | Select-Object ParentId,Id,Name
    $list_OptionalFeatures = Get-WmiObject -Class Win32_OptionalFeature | Select-Object Name,InstallState

    $ServerFeatures.Add('ServerFeatures', $list_ServerFeatures)
    $OptionalFeatures.Add('OptionalFeatures', $list_OptionalFeatures)
    $ServerFeatures
    $OptionalFeatures
}
