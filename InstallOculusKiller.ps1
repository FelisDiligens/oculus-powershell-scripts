# Checking administrator privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$HasAdminRights = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ( !$HasAdminRights ) {
    Write-Host "[!] This script is not running with administrator privileges." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] Aborted."
    exit
}

Import-Module .\odt.psm1 -Force
$paths = Import-PowerShellDataFile .\paths.psd1

# Is Oculus running?
$isRunning = ODTIsOculusRunning
if ( $isRunning ) {
    Write-Host "[!] Oculus is running." -ForegroundColor Red -BackgroundColor Black
    Write-Host "[i] Please close Oculus and try again. (Tip: Use 'StopOculusRuntime.ps1')"
    Write-Host "[i] Aborted."
    exit
}

$DASH_PARENT_PATH = "$($paths.OCULUS_PATH)\Support\oculus-dash\dash\bin"
$DASH_PATH = "$DASH_PARENT_PATH\OculusDash.exe"
$DASH_BACKUP_PATH = "$DASH_PARENT_PATH\OculusDash.exe.bak"
$DL_PARENT_PATH = ".\OculusKiller"
$DL_PATH = "$DL_PARENT_PATH\OculusDash.exe"

# ----------------------------------------------------------------------
#  Download the executable file
# ----------------------------------------------------------------------
if (!(Test-Path $DL_PATH)) {
    Write-Host "[*] Downloading OculusDash.exe"
    New-Item -ItemType Directory -Name "$DL_PARENT_PATH"
    Invoke-WebRequest -Uri "https://github.com/LibreQuest/OculusKiller/releases/download/v1.2.0/OculusDash.exe" -OutFile "$DL_PATH"
}

# Generate hashes for comparison:
Write-Host "[*] Check if installation is needed..."
$oculus_killer_hash = Get-FileHash -Path $DL_PATH -Algorithm MD5
$current_dash_hash = Get-FileHash -Path $DASH_PATH -Algorithm MD5

# ----------------------------------------------------------------------
#  Install only if needed
# ----------------------------------------------------------------------

# Are the hashes equal?
if ($oculus_killer_hash.Hash -eq $current_dash_hash.Hash) {
    Write-Host "[i] OculusKiller already installed. (MD5 hashes are equal)"
} else {
    # There is already a backup? Ask the user:
    if (Test-Path $DASH_BACKUP_PATH) {
        Write-Host "[i] OculusKiller was previously installed. ('.bak' file found)`n"
        Write-Host "[?] If you continue, you'll override the current executable ('OculusDash.exe') AND the backup." -ForegroundColor Yellow
        $decision = $Host.UI.PromptForChoice('', '    Do you want to continue?', @('&Yes'; '&No'), 1)
        if ($decision -eq 1) {
            Write-Host "[i] Aborted."
            exit
        } else {
            Write-Host "[*] Removing old backup..."
            Remove-Item -Path $DASH_BACKUP_PATH
        }
    }

    # Rename original file and copy Homeless 2.0
    Write-Host "[*] Creating backup..."
    Move-Item -Path $DASH_PATH -Destination $DASH_BACKUP_PATH
    Write-Host "[*] Installing OculusKiller..."
    Copy-Item $DL_PATH -Destination $DASH_PATH
}

# Clean up:
if (Test-Path $DL_PARENT_PATH) {
    Write-Host "[*] Cleaning up temporary files..."
    Remove-Item -Path $DL_PARENT_PATH -Recurse
}

Write-Host "[i] Done." -ForegroundColor Green