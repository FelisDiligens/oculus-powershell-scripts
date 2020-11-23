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
Write-Host "[*] Setting service startup type to Manual"
Set-Service -Name "OVRLibraryService" -StartupType "Manual"
Set-Service -Name "OVRService" -StartupType "Manual"
Write-Host "[i] Next time you want to play, you'll have to start the Oculus Client before putting the headset on."
Write-Host "[i] Done." -ForegroundColor Green