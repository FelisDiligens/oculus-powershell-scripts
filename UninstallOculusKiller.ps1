Import-Module .\paths.psm1 -Force -Global

$DASH_PARENT_PATH = "$OCULUS_PATH\Support\oculus-dash\dash\bin"
$DASH_PATH = "$DASH_PARENT_PATH\OculusDash.exe"
$DASH_BACKUP_PATH = "$DASH_PARENT_PATH\OculusDash.exe.bak"

Import-Module .\odt.psm1 -Force

# Is Oculus running?
$isRunning = ODTIsOculusRunning
if ( $isRunning ) {
    Write-Host "[!] Oculus is running." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] Please close Oculus and try again. (Tip: Use 'StopOculusRuntime.ps1')"
    Write-Host "[i] Aborted."
    exit
}

if (Test-Path $DASH_BACKUP_PATH) {
    Write-Host "[i] Backup found."
    Write-Host "[*] Uninstalling..."
    Remove-Item -Path $DASH_PATH
    Move-Item -Path $DASH_BACKUP_PATH -Destination $DASH_PATH
} else {
    Write-Host "[!] No backup found. You are out of luck." -ForegroundColor Red -BackgroundColor Black
    exit
}

Write-Host "[i] Done." -ForegroundColor Green