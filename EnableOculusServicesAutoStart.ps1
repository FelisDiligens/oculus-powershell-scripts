Import-Module .\odt.psm1 -Force

# Is Oculus running?
$isRunning = ODTIsOculusRunning
if ( $isRunning ) {
    Write-Host "[!] Oculus is running." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] Please close Oculus and try again. (Tip: Use 'StopOculusRuntime.ps1')"
    Write-Host "[i] Aborted."
    exit
}

# http://metah.ch/blog/2012/09/how-to-change-a-service-startup-type-with-powershell/
#  Automatic, Manual, Disabled
Write-Host "[*] Setting service startup type to Automatic"
Set-Service -Name "OVRLibraryService" -StartupType "Automatic"
Set-Service -Name "OVRService" -StartupType "Automatic"
Write-Host "[i] Restart may be required."
Write-Host "[i] Done." -ForegroundColor Green