$provides = "network"

function Collect-Data {
    $iface = [ordered]@{}
    $iface_config = [ordered]@{}
    $iface_instance = [ordered]@{}

    $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration
    foreach ($adapter in $adapters) {
        $i = $adapter.Index
        $iface_config[$i] = [ordered]@{}
        foreach ($p in $adapter.properties) {
            $iface_config[$i][(Insert-WMIUnderscore $p.name)] = $adapter[$p.name]
        }
    }

    $adapters = Get-WmiObject Win32_NetworkAdapter
    foreach ($adapter in $adapters) {
        $i = $adapter.Index
        $iface_instance[$i] = [ordered]@{}
        foreach ($p in $adapter.properties) {
            $iface_instance[$i][(Insert-WMIUnderscore $p.name)] = $adapter[$p.name]
        }
    }

    foreach ($i in $iface_instance.Keys) {
        if ($iface_config[$i]["ip_enabled"] -and $iface_instance[$i]["net_connection_id"]) {
            $cint = "0x" + [System.Convert]::ToString($(if ($iface_instance[$i]["interface_index"]) {$iface_instance[$i]["interface_index"]} else {$iface_instance[$i]["index"]}),16)
            $iface[$cint] = [ordered]@{}
            $iface[$cint]["configuration"] = $iface_config[$i]
            $iface[$cint]["instance"] = $iface_instance[$i]

            $iface[$cint]["counters"] = [ordered]@{}
            $iface[$cint]["addresses"] = [ordered]@{}
            $i = 0
            foreach ($ip in $iface[$cint]["configuration"]["ip_address"]) {
                $iface[$cint]["addresses"][$ip] = [ordered]@{"prefixlen" = ConvertTo-MaskLength $iface[$cint]["configuration"]["ip_subnet"][$i]}
                
                $i += 1
            }
        }
    }

    @{"network" = $iface}
}