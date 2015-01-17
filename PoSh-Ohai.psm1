<##################################################################################################
                
                __________       _________.__              ________  .__           .__ 
                \______   \____ /   _____/|  |__           \_____  \ |  |__ _____  |__|
                 |     ___/  _ \\_____  \ |  |  \   ______  /   |   \|  |  \\__  \ |  |
                 |    |  (  <_> )        \|   Y  \ /_____/ /    |    \   Y  \/ __ \|  |
                 |____|   \____/_______  /|___|  /         \_______  /___|  (____  /__|
                                       \/      \/                  \/     \/     \/  
                                                                        Module Manifest
                                                                            Version 0.1


###################################################################################################>


function Get-ComputerConfiguration {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$false)]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]$Directory = ([string](Split-Path (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Path) + "\plugins"),
        [parameter(Mandatory=$false,Position=0)]
        [string[]]$Filter
    )
    $allPlugins = @()
    foreach ($file in (Get-ChildItem $Directory -Filter *.ps1)) {
        $plugin = @{}
        $plugin["code"]  = Get-Content $file.FullName
        $plugin["provides"] = [scriptblock]::Create(($plugin["code"] + "`$provides") -join "`n").Invoke()
        $allPlugins += New-Object -TypeName psobject -Property $plugin
    }

    $usedPlugins = if ($Filter -ne $null) {
        foreach ($f in $Filter) {
            $allPlugins | Where-Object { $_.provides -contains $f }
        }
    } 
    else 
    {
        $Filter = $allPlugins.provides
        $allPlugins
    }

    $result = [ordered]@{}
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    foreach ($plugin in $usedplugins) {
        $pluginCollectedData = Invoke-Command -ScriptBlock ([scriptblock]::Create(($plugin.code + "`Collect-Data") -join "`n"))
        foreach ($prov in $plugin.provides) {
            If ($Filter -contains $prov) {
                $result[$prov] = $pluginCollectedData.$prov
            }
        }
    }
    $ErrorActionPreference = $oldErrorActionPreference

    $result | ConvertTo-Json -Depth 40
<#
 .SYNOPSIS
 The Get-ComputerConfiguration cmdlet is the main and only cmdlet that gets exported from this module. 
 It will pick up the ps1 plugins from the specified folder or the default folder if no specific directory is set.
 
 .DESCRIPTION
 See the synopsis field.

 .PARAMETER Directory
 Use this parameter to specify a directory other than the default (which is the plugin folder in the module directory) to pick plugins from.

 .EXAMPLE
 PS C:\Users\Administrator> Get-ComputerConfiguration
 This example shows how to run the cmdlet with default settings, this will grab plugins from the plugins subfolder in the module directory and run all plugins it finds.

#>
}

function Insert-WMIUnderscore {
    param(
        [parameter(Mandatory=$true)]
        [string]$name
    )

    ($name -replace [regex]"::","/" -replace [regex]"([A-Z]+)([A-Z][a-z])",'$1_$2' -replace [regex]"([a-z\d])([A-Z])",'$1_$2').ToLower()

<#
 .SYNOPSIS
 The Get-ComputerConfiguration cmdlet is the main and only cmdlet that gets exported from this module. 
 It will pick up the ps1 plugins from the specified folder or the default folder if no specific directory is set.
 
 .DESCRIPTION
 See the synopsis field.

 .PARAMETER Directory
 Use this parameter to specify a directory other than the default (which is the plugin folder in the module directory) to pick plugins from.

 .EXAMPLE
 PS C:\Users\Administrator> Get-ComputerConfiguration
 This example shows how to run the cmdlet with default settings, this will grab plugins from the plugins subfolder in the module directory and run all plugins it finds.

#>
}

Function ConvertTo-MaskLength {
    [CmdLetBinding()]
    Param(
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [Alias("Mask")]
        [String]$SubnetMask
    )
    
    Process {
        if (!$SubnetMask.Contains(".")) { Return $SubnetMask }
        $Bits = (([ipaddress]$SubnetMask).GetAddressBytes() | ForEach-Object { [Convert]::ToString($_, 2) }) -join "" -replace '[s0]'
    
        Return $Bits.Length
    }
    
<#
 .Synopsis
   Returns the length of a subnet mask.
 .Description
   ConvertTo-MaskLength accepts any IPv4 address as input, however the output value
   only makes sense when using a subnet mask.
 .Parameter SubnetMask
   A subnet mask to convert into length
#>
}

# SIG # Begin signature block
# MIIOiwYJKoZIhvcNAQcCoIIOfDCCDngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2uzNce6RgK9WMOp+WsXAIjWr
# eymggguKMIIFeDCCBGCgAwIBAgIQPafpKcj/PFgmgXzOvQfTTjANBgkqhkiG9w0B
# AQUFADCBtDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8w
# HQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBv
# ZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykxMDEuMCwG
# A1UEAxMlVmVyaVNpZ24gQ2xhc3MgMyBDb2RlIFNpZ25pbmcgMjAxMCBDQTAeFw0x
# MjAyMTYwMDAwMDBaFw0xNTAyMTUyMzU5NTlaMIG7MQswCQYDVQQGEwJVUzEOMAwG
# A1UECBMFVGV4YXMxFDASBgNVBAcTC1NhbiBBbnRvbmlvMSIwIAYDVQQKFBlSYWNr
# c3BhY2UgTWFuYWdlZCBIb3N0aW5nMT4wPAYDVQQLEzVEaWdpdGFsIElEIENsYXNz
# IDMgLSBNaWNyb3NvZnQgU29mdHdhcmUgVmFsaWRhdGlvbiB2MjEiMCAGA1UEAxQZ
# UmFja3NwYWNlIE1hbmFnZWQgSG9zdGluZzCCASIwDQYJKoZIhvcNAQEBBQADggEP
# ADCCAQoCggEBAKX2j9mGMgUFrL2yr+BBUtMP6c/qKDSr+he05hpwJjAtdACP6b/r
# EuyyFKCkjl1t7Dq5qPppQ+TGgzGgsJKJDyvb/8bA+c1RfvOxsW0zSNKwBAkIclnJ
# CFIjCeskj8HlGaUUpXNjTKhiKHq0DgqvE4H2pTOKreSV3+14S+7+nj9s+TaBs2/C
# kOGi7MsqdGaJ5e6Qjeg+DBIWum7KT1MR+l1bWfC/tUWpxlTgCCnNhIkxxpbr6j/v
# +BqQk0J16TiFxvrhwuTQPWor10USlcS8YkqiaV7uSdlgz5o7Wv+KEXstFuJZwNki
# 5295hErTxQqp6Jza+6vtCu2ktz9dFby9nOUCAwEAAaOCAXswggF3MAkGA1UdEwQC
# MAAwDgYDVR0PAQH/BAQDAgeAMEAGA1UdHwQ5MDcwNaAzoDGGL2h0dHA6Ly9jc2Mz
# LTIwMTAtY3JsLnZlcmlzaWduLmNvbS9DU0MzLTIwMTAuY3JsMEQGA1UdIAQ9MDsw
# OQYLYIZIAYb4RQEHFwMwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cudmVyaXNp
# Z24uY29tL3JwYTATBgNVHSUEDDAKBggrBgEFBQcDAzBxBggrBgEFBQcBAQRlMGMw
# JAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnZlcmlzaWduLmNvbTA7BggrBgEFBQcw
# AoYvaHR0cDovL2NzYzMtMjAxMC1haWEudmVyaXNpZ24uY29tL0NTQzMtMjAxMC5j
# ZXIwHwYDVR0jBBgwFoAUz5mp6nsm9EvJjo/X8AUm7+PSp50wEQYJYIZIAYb4QgEB
# BAQDAgQQMBYGCisGAQQBgjcCARsECDAGAQEAAQH/MA0GCSqGSIb3DQEBBQUAA4IB
# AQBHhdgW9jaKaEZwkOsKdkCmKkNwoTweUQzp61ArN4GhP5qIFho9cfUz6ytyVk5T
# Yhj/h9PWW8G3Cr6b2d27qBuKOFzgOayW0NkhMR2F24bSRrVXu9BgPUncZhfVv3pV
# Ad5fV1KR1oyBq5z3E4hjgeHJxE7CiwaEzw8+mukfFtKWPbRUhiditmURIdyNA4EO
# tOmnL4wjdYpLzBvybuUvLtbp7iLinZO9g3g/G5WvTmUzSxGGe7UBdaFvqc5GUwfF
# XjxPp9wj6v//+khaJx5zGZVFljC/LN+2UCd2ROmnPiWwewB3FD/d8in4Def+J4W6
# eDEXOfheeGUAxlxSmy58qZtxMIIGCjCCBPKgAwIBAgIQUgDlqiVW/BqG7ZbJ1Esz
# xzANBgkqhkiG9w0BAQUFADCByjELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlT
# aWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTowOAYD
# VQQLEzEoYykgMjAwNiBWZXJpU2lnbiwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVz
# ZSBvbmx5MUUwQwYDVQQDEzxWZXJpU2lnbiBDbGFzcyAzIFB1YmxpYyBQcmltYXJ5
# IENlcnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzUwHhcNMTAwMjA4MDAwMDAwWhcN
# MjAwMjA3MjM1OTU5WjCBtDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWdu
# LCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQL
# EzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAo
# YykxMDEuMCwGA1UEAxMlVmVyaVNpZ24gQ2xhc3MgMyBDb2RlIFNpZ25pbmcgMjAx
# MCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPUjS16l14q7MunU
# V/fv5Mcmfq0ZmP6onX2U9jZrENd1gTB/BGh/yyt1Hs0dCIzfaZSnN6Oce4DgmeHu
# N01fzjsU7obU0PUnNbwlCzinjGOdF6MIpauw+81qYoJM1SHaG9nx44Q7iipPhVuQ
# AU/Jp3YQfycDfL6ufn3B3fkFvBtInGnnwKQ8PEEAPt+W5cXklHHWVQHHACZKQDy1
# oSapDKdtgI6QJXvPvz8c6y+W+uWHd8a1VrJ6O1QwUxvfYjT/HtH0WpMoheVMF05+
# W/2kk5l/383vpHXv7xX2R+f4GXLYLjQaprSnTH69u08MPVfxMNamNo7WgHbXGS6l
# zX40LYkCAwEAAaOCAf4wggH6MBIGA1UdEwEB/wQIMAYBAf8CAQAwcAYDVR0gBGkw
# ZzBlBgtghkgBhvhFAQcXAzBWMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy52ZXJp
# c2lnbi5jb20vY3BzMCoGCCsGAQUFBwICMB4aHGh0dHBzOi8vd3d3LnZlcmlzaWdu
# LmNvbS9ycGEwDgYDVR0PAQH/BAQDAgEGMG0GCCsGAQUFBwEMBGEwX6FdoFswWTBX
# MFUWCWltYWdlL2dpZjAhMB8wBwYFKw4DAhoEFI/l0xqGrI2Oa8PPgGrUSBgsexku
# MCUWI2h0dHA6Ly9sb2dvLnZlcmlzaWduLmNvbS92c2xvZ28uZ2lmMDQGA1UdHwQt
# MCswKaAnoCWGI2h0dHA6Ly9jcmwudmVyaXNpZ24uY29tL3BjYTMtZzUuY3JsMDQG
# CCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AudmVyaXNpZ24u
# Y29tMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDAzAoBgNVHREEITAfpB0w
# GzEZMBcGA1UEAxMQVmVyaVNpZ25NUEtJLTItODAdBgNVHQ4EFgQUz5mp6nsm9EvJ
# jo/X8AUm7+PSp50wHwYDVR0jBBgwFoAUf9Nlp8Ld7LvwMAnzQzn6Aq8zMTMwDQYJ
# KoZIhvcNAQEFBQADggEBAFYi5jSkxGHLSLkBrVaoZA/ZjJHEu8wM5a16oCJ/30c4
# Si1s0X9xGnzscKmx8E/kDwxT+hVe/nSYSSSFgSYckRRHsExjjLuhNNTGRegNhSZz
# A9CpjGRt3HGS5kUFYBVZUTn8WBRr/tSk7XlrCAxBcuc3IgYJviPpP0SaHulhncyx
# kFz8PdKNrEI9ZTbUtD1AKI+bEM8jJsxLIMuQH12MTDTKPNjlN9ZvpSC9NOsm2a4N
# 58Wa96G0IZEzb4boWLslfHQOWP51G2M/zjF8m48blp7FU3aEW5ytkfqs7ZO6Xcgh
# U8KCU2OvEg1QhxEbPVRSloosnD2SGgiaBS7Hk6VIkdMxggJrMIICZwIBATCByTCB
# tDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
# ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
# YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykxMDEuMCwGA1UEAxMl
# VmVyaVNpZ24gQ2xhc3MgMyBDb2RlIFNpZ25pbmcgMjAxMCBDQQIQPafpKcj/PFgm
# gXzOvQfTTjAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU19F+YtcDDVGMVNPMzA+ABWqIYpEwDQYJ
# KoZIhvcNAQEBBQAEggEAgynxT7MPWArI1AjDUEyh5Ga0pxoCx2kwes3nR4mVd7h4
# 7BMLIddvEob/H1pUsvsBQkSc/OY8ErpYitGKm9QbC/yqYh1anpv90aITQ32NaOxn
# rrHO3PX0OwRhONJD+eSjkSywGvOMALGH07j6y93p6T4jALdsbCpFoMl8001cmNz1
# g99ldiLt9/um+3kTjkjPPIZ3UuVgw7rtcByKMRkM9yOM2ybVns5vwjflQcWueF4D
# yslfJU0PUn5UjOjIdnPZrvn0PALf2XJ7ppReCQf4Y4y3BI8tbeDz1/zHlEhv3a36
# rLv9fD6Cf9/2R9sB//sKq0WTE/hTCCYKmcemJWApkQ==
# SIG # End signature block
