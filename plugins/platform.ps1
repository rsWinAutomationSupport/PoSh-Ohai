$provides = 'os','platform_family','platform','platform_version','platform_architecture','platform_servicepack_major','platform_servicepack_minor','powershell_version'
function Collect-Data {
    if(((Get-CimInstance Win32_OperatingSystem).CreationClassName) -eq 'Win32_OperatingSystem'){
        $OperatingSystem = 'Windows'
    }
    $os = @{
        'os' = $OperatingSystem
    }
    $platform_family    = @{
        'platform_family' = $OperatingSystem
    }
    $platform    = @{
        'platform' = $((Get-CimInstance Win32_OperatingSystem).Caption)
    }
    $platform_version    = @{
        'platform_version' = $((Get-CimInstance Win32_OperatingSystem).version)
    }
    $platform_architecture    = @{
        'platform_architecture' = $((Get-CimInstance Win32_OperatingSystem).OSArchitecture)
    }
    $platform_servicepack_major    = @{
        'platform_servicepack_major' = $((Get-CimInstance Win32_OperatingSystem).ServicePackMajorVersion)
    }
    $platform_servicepack_minor    = @{
        'platform_servicepack_minor' = $((Get-CimInstance Win32_OperatingSystem).ServicePackMinorVersion)
    }
    $powershell_version    = @{
        'powershell_version' = $($PSVersionTable.PSVersion.ToString())
    }
    $os +
    $platform_family +
    $platform +
    $platform_version +
    $platform_architecture +
    $platform_servicepack_major +
    $platform_servicepack_minor +
    $powershell_version
}
