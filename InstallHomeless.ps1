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

# https://www.reddit.com/r/oculus/comments/8uf1sm/oculushomeless_use_dash_without_home_20/
# http://www.emuvr.net/download/OculusHomeless.zip

$HOME2_PATH = "$($paths.OCULUS_PATH)\Support\oculus-worlds\Home2\Binaries\Win64\"
$EXEC_PATH = $HOME2_PATH + "Home2-Win64-Shipping.exe"
$REPL_PATH = ".\OculusHomeless\Home2-Win64-Shipping.exe"
$BGCOLOR_PATH = $HOME2_PATH + "background_color.txt"

# ----------------------------------------------------------------------
#  Download the archive
# ----------------------------------------------------------------------
if (!(Test-Path $REPL_PATH)) {
    Write-Host "[*] Downloading OculusHomeless.zip"
    Invoke-WebRequest -Uri "http://www.emuvr.net/download/OculusHomeless.zip" -OutFile ".\OculusHomeless.zip"
    Write-Host "[*] Unpacking OculusHomeless.zip"
    Expand-Archive ".\OculusHomeless.zip" -DestinationPath ".\OculusHomeless"
}

# Generate hashes for comparison:
Write-Host "[*] Check if installation is needed..."
$homeless_hash = Get-FileHash -Path $REPL_PATH -Algorithm MD5
$installed_exec_hash = Get-FileHash -Path $EXEC_PATH -Algorithm MD5

# ----------------------------------------------------------------------
#  Install only if needed
# ----------------------------------------------------------------------

# Are the hashes equal?
if ($homeless_hash.Hash -eq $installed_exec_hash.Hash) {
    Write-Host "[i] Oculus Homeless already installed. (MD5 hashes are equal)"
} else {
    # There is already a backup? Ask the user:
    if (Test-Path ($EXEC_PATH + ".bak")) {
        Write-Host "[i] Oculus Homeless was previously installed. ('.bak' file found)`n"
        Write-Host "[?] If you continue, you'll override the current executable ('Home2-Win64-Shipping.exe') AND the backup." -ForegroundColor Yellow
        $decision = $Host.UI.PromptForChoice('', '    Do you want to continue?', @('&Yes'; '&No'), 1)
        if ($decision -eq 1) {
            Write-Host "[i] Aborted."
            exit
        } else {
            Write-Host "[*] Removing old backup..."
            Remove-Item -Path ($EXEC_PATH + ".bak")
        }
    }

    # Rename original file and copy Homeless 2.0
    Write-Host "[*] Creating backup..."
    Move-Item -Path $EXEC_PATH -Destination ($EXEC_PATH + ".bak")
    Write-Host "[*] Installing Oculus Homeless..."
    Copy-Item $REPL_PATH -Destination $EXEC_PATH
}

# ----------------------------------------------------------------------
#  Wrapping up
# ----------------------------------------------------------------------

# Create a "background_color.txt" file, if it doesn't exist:
if (!(Test-Path $BGCOLOR_PATH)) {
    Write-Host "[*] Setting background color to black."
    Write-Output "0.0 0.0 0.0" | Out-File -FilePath $BGCOLOR_PATH
}

# Clean up:
if (Test-Path ".\OculusHomeless") {
    Write-Host "[*] Cleaning up temporary files..."
    Remove-Item -Path ".\OculusHomeless" -Recurse
    Remove-Item -Path ".\OculusHomeless.zip"
}

Write-Host "[i] Done." -ForegroundColor Green