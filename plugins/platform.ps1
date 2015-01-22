$provides = 'os','platform_family','platform','platform_version','platform_architecture','platform_servicepack_major','platform_servicepack_minor','powershell_version'
function Collect-Data {
    $os = @{
        'os' = $(((Get-CimInstance Win32_OperatingSystem).RegisteredUser).split(' ')[0])
    }
    $platform_family    = @{
        'platform_family' = $(((Get-CimInstance Win32_OperatingSystem).RegisteredUser).split(' ')[0])
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
