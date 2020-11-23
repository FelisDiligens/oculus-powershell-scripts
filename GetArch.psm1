# https://superuser.com/questions/358434/how-to-check-if-a-binary-is-32-or-64-bit-on-windows
function GetArch {
    param (
        [Parameter(Mandatory=$true)][string]$Path
    )

    $arch = "unknown"

    if (!(Test-Path $Path)) {
        return $arch
    }

    # Read file in bytes:
    $bytes = [System.IO.File]::ReadAllBytes($Path)

    for ($i = 0; $i -lt 512; $i++) {
        # First occurence of "PE":
        if ($bytes[$i] -eq 0x50 -and $bytes[$i + 1] -eq 0x45) {
            # Header looks like this:
            # 0x50 0x45 0x00 0x00 0x?? 0x??
            #  P    E              ?    ?
            if ($bytes[$i + 4] -eq 0x4C -and $bytes[$i + 5] -eq 0x01) {
                $arch = "x86"
            } elseif ($bytes[$i + 4] -eq 0x64 -and $bytes[$i + 5] -eq 0x86) {
                $arch = "x64"
            }
        }
    }

    return $arch
}