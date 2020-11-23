param (
    [Parameter(Mandatory=$true)][string]$Path,
    [string]$Arch = "auto"
)

Import-Module .\GetArch.psm1 -Force

# OpenComposite: https://gitlab.com/znixian/OpenOVR/blob/master/README.md

# ----------------------------------------------------------------------
#  Checking parameters
# ----------------------------------------------------------------------
if ($Arch -ne "x64" -and $Arch -ne "x86" -and $Arch -ne "auto") {
    Write-Host "[!] Invalid parameter: Arch=$Arch`nPlease use either 'x64', 'x86' or 'auto'." -ForegroundColor Red -BackgroundColor Black
    exit
} elseif ($Arch -ne "auto") {
    Write-Host "[i] Using $Arch architecture."
} else {
    Write-Host "[i] Architecture will be detected automatically."
}

if (!(Test-Path $Path)) {
    Write-Host "[!] Directory doesn't exist: $Path" -ForegroundColor Red -BackgroundColor Black
    exit
}

if (!((Get-Item $Path) -is [System.IO.DirectoryInfo])) {
    Write-Host "[!] Path is not a directory." -ForegroundColor Red -BackgroundColor Black
    exit
}

# ----------------------------------------------------------------------
#  Downloading *.dll files if necessary
# ----------------------------------------------------------------------
if (!((Test-Path ".\OpenComposite\openvr_api_x64.dll") -and (Test-Path ".\OpenComposite\openvr_api_x86.dll"))) {
    New-Item -ItemType Directory -Force -Path ".\OpenComposite"
    Write-Host "[*] Downloading DLL files"
    Invoke-WebRequest -Uri "https://znix.xyz/OpenComposite/download.php?arch=x86" -OutFile ".\OpenComposite\openvr_api_x86.dll"
    Invoke-WebRequest -Uri "https://znix.xyz/OpenComposite/download.php?arch=x64" -OutFile ".\OpenComposite\openvr_api_x64.dll"
}

# Get MD5 hashes for later
$replHashx86 = Get-FileHash -Path ".\OpenComposite\openvr_api_x86.dll" -Algorithm MD5
$replHashx64 = Get-FileHash -Path ".\OpenComposite\openvr_api_x64.dll" -Algorithm MD5

# ----------------------------------------------------------------------
#  Searching for *.dll file in directory
# ----------------------------------------------------------------------
Write-Host "[*] Searching for 'openvr_api.dll'"

# Get all "openvr_api.dll" occurrences recursively
$files = Get-ChildItem -Path $Path -Filter "openvr_api.dll" -Recurse -ErrorAction SilentlyContinue -Force
$fileCount = ([array]$files).Length # https://stackoverflow.com/a/9580310

if ($fileCount -gt 0) {
    Write-Host "[*] Replacing all matching DLL files, if necessary..."
    $skipped = 0
    $replaced = 0

    # Iterate through all occurrences
    foreach ($f in $files) {
        $liveHash = Get-FileHash -Path $f.FullName -Algorithm MD5

        # Is there a backup?
        if (Test-Path ($f.DirectoryName + "\openvr_api_org.dll")) {
            $skipped++
            Write-Host ("[i] Skipping " + $f.FullName + " ('openvr_api_org.dll' in folder)")

        # Are the hashes equal?
        } elseif (($liveHash.Hash -eq $replHashx86.Hash) -or ($liveHash.Hash -eq $replHashx64.Hash)) {
            $skipped++
            Write-Host ("[i] Skipping " + $f.FullName + " (MD5 hashes are equal)")

        # Replace it otherwise:
        } else {
            $replaced++
            $_Arch = $Arch
            if ($Arch -eq "auto") {
                $_Arch = GetArch -Path $f.FullName
                Write-Host ("[i] $_Arch detected: " + $f.FullName)
            }
            Write-Host ("[*] Replacing " + $f.FullName)

            # Rename original file and copy replacement:
            Move-Item -Path $f.FullName -Destination ($f.DirectoryName + "\openvr_api_org.dll")
            Copy-Item -Path ".\OpenComposite\openvr_api_$_Arch.dll" -Destination $f.FullName
        }
    }
    Write-Host "[i] Done." -ForegroundColor Green
    Write-Host "[i] Statistics:`n    - Matching files: $fileCount`n    - Replaced:       $replaced`n    - Skipped:        $skipped"
} else {
    Write-Host "[!] FAILED: No 'openvr_api.dll' found in directories and subdirectories." -ForegroundColor Red -BackgroundColor Black
}