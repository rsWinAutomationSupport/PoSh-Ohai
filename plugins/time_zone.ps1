$provides = 'time_zone'

function Collect-Data {
    $output = New-Object System.Collections.Specialized.OrderedDictionary
    
    $timezone = New-Object System.Collections.Specialized.OrderedDictionary
    $timezone = Get-WmiObject Win32_TimeZone
    $output.Add('time_zone',$timezone.caption)
    $output
}
