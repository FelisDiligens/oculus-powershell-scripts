Write-Host "[!] Work-In-Progress. Don't use this script." -ForegroundColor Red -BackgroundColor Black
exit

# Checking administrator privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$HasAdminRights = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ( !$HasAdminRights ) {
    Write-Host "[!] This script is not running with administrator privileges." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] Aborted."
    exit
}

#& "C:\Program Files\Oculus\Support\oculus-runtime\OVRServiceLauncher.exe" -start
#Start-Process -FilePath "C:\Program Files\Oculus\Support\oculus-runtime\OVRServiceLauncher.exe" -WorkingDirectory "C:\Program Files\Oculus\Support\oculus-runtime" -ArgumentList "-start"
#Start-Process "C:\Program Files\Oculus\Support\oculus-client\OculusClient.exe"

Start-Service "OVRService"
Write-Host "[i] Done." -ForegroundColor Green