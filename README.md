PoSh-Ohai
=========

PowerShell interpretation of opscode's Ohai

Usage:

Place contents of this repo in C:\Program Files\WindowsPowershell\Modules\Posh-Ohai


<pre>
Import-Module Posh-Ohai
Get-ComputerConfiguration -moduleDirectory "C:\Program Files\WindowsPowershell\Modules\Posh-Ohai" -outpath "C:\users\Administrator\Desktop" -role web
</pre>
