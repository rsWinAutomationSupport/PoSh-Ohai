$provides = "services"

function Collect-Data {
  $services = [ordered]@{}
  $list_services = Get-WmiObject -Class Win32_Service | select Name,ProcessId,State,StartMode,Status

  [ordered]@{"services" = $list_services}
}
