$provides = 'dot_net_version'
function Collect-Data {
    $output = New-Object System.Collections.Specialized.OrderedDictionary
    $dot_net_version = New-Object System.Collections.Specialized.OrderedDictionary
    
    $list_versions = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
                            Get-ItemProperty -name Version -EA 0 |
                            Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
                            Select-Object @{Name='Name';Expression={$_.PSChildName}}, Version

                     #(Get-ChildItem -Path $Env:windir\Microsoft.NET\Framework |
                     #      Where-Object {$_.PSIsContainer -eq $true } |
                     #      Where-Object {$_.Name -match 'v\d\.\d'} |
                     #      Sort-Object -Property Name -Descending |
                     #      Select-Object -First 1).Name

    $output.Add('dot_net_version',$list_versions)
    $output
}
