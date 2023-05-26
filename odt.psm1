$paths = Import-PowerShellDataFile .\paths.psd1

$ODT_PATH = "$($paths.OCULUS_PATH)\Support\oculus-diagnostics\OculusDebugToolCLI.exe"

# How does it work?
# * Write arguments (and 'exit') to a text file
# * Execute OculusDebugToolCLI.exe with text file path as argument
# * Delete text file
function ODTSendCommand {
    param(
        $cmd
    )

    Set-Content -Path "$env:UserProfile\cmds.txt" -Value "$cmd`nexit" -Force
    & $ODT_PATH -f "$env:UserProfile\cmds.txt"
    Remove-Item -Path "$env:UserProfile\cmds.txt"
}


function ODTIsOculusRunning {
    $Process = Get-Process -Name "OculusClient" -ErrorAction SilentlyContinue
    #return $Process -eq $null
    return [bool]$Process
}


# Asynchronous SpaceWrap
function ODTDisableASW {
    ODTSendCommand "server:asw.Off"
}

function ODTEnableASW {
    ODTSendCommand "server:asw.Auto"
}

# Other modes:
# Force 45fps, ASW enabled:  "server:asw.Clock45"
# Force 45fps, ASW disabled: "server:asw.Sim45"



# Super sampling / Pixel density
function ODTSetSupersampling ([double]$density) {
    if ($density -gt 0) {
        ODTSendCommand "service set-pixels-per-display-pixel $density"
    } else {
        Write-Host "Invalid number. Density must be greater than 0."
    }
}