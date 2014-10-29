$provides = "loggedon_users"

function Collect-Data {
  $loggedon_users = [ordered]@{}
  $session_user = @{}

  $regex_antecedent = '.+Domain="(.+)",Name="(.+)"$'
  $regex_dependent = '.+LogonId="(\d+)"$'

  $logontype = @{
    "0" = "Local System"
    "2" = "Interactive"
    "3" = "Network"
    "4" = "Batch"
    "5" = "Service"
    "7" = "Unlock"
    "8" = "NetworkCleartext"
    "9" = "NewCredentials"
    "10" = "RemoteInteractive"
    "11" = "CachedInteractive"
  }

  $logon_sessions = gwmi win32_logonsession -ComputerName $env:COMPUTERNAME | select AuthenticationPackage,LogonId,LogonType,StartTime
  $logon_users = gwmi win32_loggedonuser -ComputerName $env:COMPUTERNAME | select Antecedent, Dependent

  $logon_users |foreach {
    $_.antecedent -match $regex_antecedent > $null
    $username = $matches[1] + "\" + $matches[2]
    $_.dependent -match $regex_dependent > $null
    $session = $matches[1]
    $session_user[$session] += $username
  }

  $output = $logon_sessions | foreach {
    $starttime = [management.managementdatetimeconverter]::todatetime($_.starttime)
    $loggedonuser = New-Object -TypeName psobject
    $loggedonuser | Add-Member -MemberType NoteProperty -Name "Session" -Value $_.logonid
    $loggedonuser | Add-Member -MemberType NoteProperty -Name "User" -Value $session_user[$_.logonid]
    $loggedonuser | Add-Member -MemberType NoteProperty -Name "Type" -Value $logontype[$_.logontype.tostring()]
    $loggedonuser | Add-Member -MemberType NoteProperty -Name "Auth" -Value $_.authenticationpackage
    $loggedonuser | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $starttime
    $loggedonuser
  }
  [ordered]@{"loggedon_users"=$output}
}
