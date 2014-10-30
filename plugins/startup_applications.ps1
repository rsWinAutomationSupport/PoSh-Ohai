$provides = "startup_applications"
function Collect-Data {
  $startup_applications = [ordered]@{}

  $list_startup_applications  = Get-CimInstance Win32_StartupCommand |
                                Select-Object Name, command, Location, User

  [ordered]@{"startup_applications"=$list_startup_applications}
}
