trap
{
    Write-Error -ErrorRecord $_
    exit 1
}

If (Test-Path -Path (Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai")) {
    try {
        Write-Host "Found existing temp dir in $($env:TEMP), trying to delete!"
        Remove-Item -Force -Recurse -Path (Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai") -ErrorAction Stop
    } catch {
        throw "Temp folder exists and can't be deleted, stopping"
    }
}

Write-Host "Downloading Zip file from github to $(Join-Path -Path $env:TEMP -ChildPath 'PoSh-Ohai-master.zip')"
(New-Object -TypeName System.Net.WebClient).DownloadFile("http://12d9673e1fdcef86bf0a-162ee3689e7f81d290994e20942dc617.r59.cf3.rackcdn.com/PoSh-Ohai-master.zip",(Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai-master.zip"))

Write-Host "Adding ZipStorer Type to decompress downloaded Zip file"
If (-not ("System.IO.Compression.ZipStorer" -as [type])) {
    Add-Type -TypeDefinition (New-Object -TypeName System.Net.WebClient).DownloadString("http://12d9673e1fdcef86bf0a-162ee3689e7f81d290994e20942dc617.r59.cf3.rackcdn.com/ZipStorer.cs") -Language CSharp
}

Write-Host "Decompressing zip file to $env:TEMP"
$zip = [System.IO.Compression.ZipStorer]::Open((Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai-master.zip"),[System.IO.FileAccess]::Read)
$extractSuccessful = $true
foreach ($file in $zip.ReadCentralDir()) { 
    if ( -not $zip.ExtractFile($file,(Join-Path -Path $env:TEMP -ChildPath $file.FilenameInZip))) {
	    $extractSuccessful = $false
	}
}
$zip.Close()


Rename-Item -Path (Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai-master") -NewName (Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai")
$manifest = [scriptblock]::Create((Get-Content (Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai\PoSh-Ohai.psd1") -Raw)).Invoke()

if ($manifest.ModuleVersion -gt (Get-Module -ListAvailable PoSh-Ohai).version) {
    Write-Host "Downloaded version ($($manifest.ModuleVersion)) greater than existing version ($( If ((Get-Module -ListAvailable PoSh-Ohai).version) {(Get-Module -ListAvailable PoSh-Ohai).version} else {'not installed'})), trying to copy new version..."
    Remove-Module PoSh-Ohai -ErrorAction SilentlyContinue
    try {
        Copy-Item -Path (Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai") -Destination $($env:PSModulePath.Split(";") | Where-Object { $_.StartsWith($env:SystemRoot)}) -Recurse -Force
    } catch {
        throw "The attempt to copy the module to its location failed, stopping"
    }
} else {
        Write-Host "Downloaded version ($($manifest.ModuleVersion)) not greater than existing version ($( If ((Get-Module -ListAvailable PoSh-Ohai).version) {(Get-Module -ListAvailable PoSh-Ohai).version} else {'not installed'})), nothing to do..."
}

Write-Host "Done, deleting temp files..."
Remove-Item -Path (Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai") -ErrorAction SilentlyContinue -Recurse -Force
Remove-Item -Path (Join-Path -Path $env:TEMP -ChildPath "PoSh-Ohai-master.zip") -ErrorAction SilentlyContinue -Force