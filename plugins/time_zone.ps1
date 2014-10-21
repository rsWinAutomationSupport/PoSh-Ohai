$provides = "time_zone"

function Collect-Data {
  $timezone = [ordered]@{}
  $timezone = Get-WmiObject Win32_TimeZone
  [ordered]@{"time_zone"=$timezone.caption} 
}
