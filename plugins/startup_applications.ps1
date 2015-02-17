$provides = 'startup_applications'
function Collect-Data {
    $output = New-Object System.Collections.Specialized.OrderedDictionary
    $startup_applications = New-Object System.Collections.Specialized.OrderedDictionary

    $list_startup_applications  = Get-WmiObject Win32_StartupCommand |
                                    Select-Object Name, command, Location, User
    
    $output.Add('startup_applications',$list_startup_applications)
    $output
}
