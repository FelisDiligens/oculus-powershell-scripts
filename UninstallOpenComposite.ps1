param (
    [Parameter(Mandatory=$true)][string]$Path
)

Write-Host "[*] Searching for 'openvr_api_org.dll'"
$files = Get-ChildItem -Path $Path -Filter "openvr_api_org.dll" -Recurse -ErrorAction SilentlyContinue -Force
$fileCount = ([array]$files).Length # https://stackoverflow.com/a/9580310
if ($fileCount -gt 0) {
    Write-Host "[*] Restoring all matching DLL files"
    foreach ($f in $files) {
        $nowReplaced++
        Remove-Item -Path ($f.DirectoryName + "\openvr_api.dll")
        Move-Item -Path $f.FullName -Destination ($f.DirectoryName + "\openvr_api.dll")
    }
    Write-Host "[i] Done." -ForegroundColor Green
} else {
    Write-Host "[!] No backups ('openvr_api_org.dll') found in directories and subdirectories."  -ForegroundColor Red -BackgroundColor Black
}