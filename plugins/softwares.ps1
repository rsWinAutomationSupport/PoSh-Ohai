$provides = "softwares"
function Collect-Data {
  $softwares = [ordered]@{}

  $list_softwares = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

  [ordered]@{"softwares" = $list_softwares}
}
