Import-Module .\paths.psm1 -Force -Global

$HOME2_PATH = "$OCULUS_PATH\Support\oculus-worlds\Home2\Binaries\Win64\"
$EXEC_PATH = $HOME2_PATH + "Home2-Win64-Shipping.exe"
$BGCOLOR_PATH = $HOME2_PATH + "background_color.txt"

Import-Module .\odt.psm1 -Force

# Is Oculus running?
$isRunning = ODTIsOculusRunning
if ( $isRunning ) {
    Write-Host "[!] Oculus is running." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] Please close Oculus and try again. (Tip: Use 'StopOculusRuntime.ps1')"
    Write-Host "[i] Aborted."
    exit
}

if (Test-Path ($EXEC_PATH + ".bak")) {
    Write-Host "[i] Backup found."
    Write-Host "[*] Uninstalling..."
    Remove-Item -Path $EXEC_PATH
    Move-Item -Path ($EXEC_PATH + ".bak") -Destination $EXEC_PATH
    Remove-Item -Path $BGCOLOR_PATH
} else {
    Write-Host "[!] No backup found. You are out of luck." -ForegroundColor Red -BackgroundColor Black
    exit
}

Write-Host "[i] Done." -ForegroundColor Green