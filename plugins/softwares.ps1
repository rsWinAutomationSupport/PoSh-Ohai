$provides = 'softwares'
function Collect-Data {
    $output = New-Object System.Collections.Specialized.OrderedDictionary
    $softwares = New-Object System.Collections.Specialized.OrderedDictionary

    $list_softwares = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

    $output.Add('softwares' , $list_softwares)
    $output
}
