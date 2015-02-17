$provides = 'services'

function Collect-Data {
    $output = New-Object System.Collections.Specialized.OrderedDictionary
    $services = New-Object System.Collections.Specialized.OrderedDictionary
    $list_services = Get-WmiObject -Class Win32_Service | Select-Object Name,ProcessId,State,StartMode,Status

    $output.Add('services' , $list_services)
    $output
}
