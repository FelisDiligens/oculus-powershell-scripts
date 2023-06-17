# Set $OCULUS_PATH to environment variable %OCULUSBASE%:
$OCULUS_PATH = "$env:OCULUSBASE"

# Fallback to default location, if %OCULUSBASE% is unset:
if ("$env:OCULUSBASE" -eq "") {
    $OCULUS_PATH = "C:\Program Files\Oculus"
}

# Change $OCULUS_PATH here:
# $OCULUS_PATH = "D:\Oculus"

Export-ModuleMember -Variable OCULUS_PATH