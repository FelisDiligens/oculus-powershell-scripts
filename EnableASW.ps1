Import-Module .\odt.psm1 -Force

# Only continue if Oculus is actually running:
$isRunning = ODTIsOculusRunning
if ( !$isRunning ) {
    Write-Host "[!] Oculus is not running." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] In order to enable/disable ASW, Oculus has to run."
    Write-Host "    Note that you'll have to run this script everytime you (re)start Oculus."
    Write-Host "[i] Aborted."
    exit
}

Write-Host "[*] Enabling ASW..."
ODTEnableASW
Write-Host "[i] Done." -ForegroundColor Green