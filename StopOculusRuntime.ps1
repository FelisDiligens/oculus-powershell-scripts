# Checking administrator privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$HasAdminRights = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ( !$HasAdminRights ) {
    Write-Host "[!] This script is not running with administrator privileges." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] Aborted."
    exit
}

#$ErrorActionPreference = "SilentlyContinue"

# Processes:
Write-Host "[*] Stopping processes..."
Stop-Process -Name "OVRRedir" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "OVRServer_x64" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "OVRServiceLauncher" -Force -ErrorAction SilentlyContinue

# Services:
Write-Host "[*] Stopping services..."
Stop-Service "OVRService" -Force -ErrorAction SilentlyContinue
Stop-Service "OVRLibraryService" -Force -ErrorAction SilentlyContinue # Probably not running...
Stop-Service "OculusClient" -Force -ErrorAction SilentlyContinue

<#
Missing?
oculus-platform-runtime
OculusClient
#>

#Write-Host "[i] You can savely ignore any errors. They are shown when the script tries to stop processes which aren't currently running."
Write-Host "[i] Done." -ForegroundColor Green