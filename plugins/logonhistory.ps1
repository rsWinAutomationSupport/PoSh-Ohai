$provides = 'logonhistory'

function Collect-Data {
    $output = New-Object System.Collections.Specialized.OrderedDictionary
    $logons = New-Object System.Collections.Specialized.OrderedDictionary
    $query = "*[System[(EventID=4624)]] and (*[EventData[Data[@Name='LogonType']=2]] or *[EventData[Data[@Name='LogonType']=10]])"

    try {
        $events = Get-WinEvent -LogName Security -FilterXPath $query | Sort-Object TimeCreated | Select-Object -First 10

        foreach ($event in $events) {
            [xml]$xmlevent = $event.ToXml()

            $eventdata = @{}
            foreach ($item in $xmlevent.Event.EventData.Data) {
                $eventdata[$item.Name] = $item.'#text'
            }

            $logons[$eventdata['TargetLogonId']] = [ordered]@{}
            $logons[$eventdata['TargetLogonId']]['user'] = "$($eventdata['TargetDomainName'])\\$($eventdata['TargetUserName'])"
            $logons[$eventdata['TargetLogonId']]['authpackage'] = $eventdata['AuthenticationPackageName']
            $logons[$eventdata['TargetLogonId']]['logontype'] = $eventdata['LogonType']
            $logons[$eventdata['TargetLogonId']]['process'] = $eventdata['ProcessName']
            $logons[$eventdata['TargetLogonId']]['sourceip'] = $eventdata['IpAddress']
            $logons[$eventdata['TargetLogonId']]['time'] = $xmlevent.Event.System.TimeCreated.SystemTime
        }
    }
    catch {
        #$logons["Error"] = $_.Exception.ToString()
    }

    $output.Add('logonhistory' , $logons)
    $output
}
