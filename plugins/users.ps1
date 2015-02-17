$provides = 'users'

function Collect-Data {
    $output = New-Object System.Collections.Specialized.OrderedDictionary
    $users = New-Object System.Collections.Specialized.OrderedDictionary

    $list_users = (Get-WmiObject -Class Win32_UserAccount) | Select-Object Status,Caption,PasswordExpires,AccountType,Description,Disabled,Domain,FullName,InstallDate,LocalAccount,Lockout,Name,PasswordChangeable,PasswordRequired,SID,SIDType,Site,Container

    $output.Add('users',$list_users)
    $output
}
