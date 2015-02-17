$provides = 'firewall_profiles'

function Collect-Data {
    $output = New-Object System.Collections.Specialized.OrderedDictionary
    $firewall_profiles = New-Object System.Collections.Specialized.OrderedDictionary
    
    $find_rule = netsh advfirewall show allprofiles
    $domainProfileInit = (($find_rule[3].ToString()) -match 'ON')
    $privateProfileInit = (($find_rule[20].ToString()) -match 'ON')
    $publicProfileInit = (($find_rule[37].ToString()) -match 'ON')

    $firewallInitialStatus = $false
    $firewallFinalStatus = $false
    Function Check-Profile($istatus){
        $find_rule = netsh advfirewall show allprofiles
        $domainProfile = (($find_rule[3].ToString()) -match 'ON')
        $privateProfile = (($find_rule[20].ToString()) -match 'ON')
        $publicProfile = (($find_rule[37].ToString()) -match 'ON')
        if (-not($DomainProfile) -or -not($PrivateProfile) -or -not($PublicProfile)){
            $istatus = $false
        }
        else{
            $istatus = $true
        }
        $firewall_profiles.add('Status', $istatus)
        $firewall_profiles.add('Domain', $domainProfile)
        $firewall_profiles.add('Private', $privateProfile)
        $firewall_profiles.add('Public', $publicProfile)
        #return $istatus,$domainProfile,$privateProfile,$publicProfile
    }
    Check-Profile
    $output.Add('firewall_profiles' , $firewall_profiles)
    $output 
}
