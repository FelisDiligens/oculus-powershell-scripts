param (
    [int]$Width = 1280,
    [int]$Height = 1280,
    [double]$FOVMultiplier = 1.3
)

# PS> .\StartMirror.ps1 1280 720 1.0

# https://developer.oculus.com/documentation/native/pc/dg-compositor-mirror/

Import-Module .\odt.psm1 -Force
$paths = Import-PowerShellDataFile .\paths.psd1

# Only continue if Oculus is actually running:
$isRunning = ODTIsOculusRunning
if ( !$isRunning ) {
    Write-Host "[!] Oculus is not running." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] In order to start the mirror, Oculus has to run."
    Write-Host "[i] Aborted."
    exit
}

$MIRROR_EXEC = "$($paths.OCULUS_PATH)\Support\oculus-diagnostics\OculusMirror.exe"

if ($FOVMultiplier -lt 0) {
    Write-Host "[!] Invalid FOV multiplier. Multiplier must be greater than 0." -ForegroundColor Red -BackgroundColor Black
    exit
}


Write-Host "[*] Starting Mirror..."
& $MIRROR_EXEC --Size $Width $Height --FovTanAngleMultiplier $FOVMultiplier $FOVMultiplier --DisableTimewarp --RightEyeOnly --IncludeSystemGui --IncludeNotifications --SymmetricFov --DisableFovStencil
# --IncludeGuardian

Write-Host "[i] Done." -ForegroundColor Green