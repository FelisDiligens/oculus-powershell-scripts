# Set "High Performance" power profile using powercfg
# powercfg /SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Disable selective suspend (USB) using powercfg
# Sources:
# * https://www.tenforums.com/tutorials/73187-turn-off-usb-selective-suspend-windows-10-a.html
# * https://winaero.com/blog/enable-usb-selective-suspend-windows-10/
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

# Disable selective suspend (USB) by creating registry key
# Source: http://9b5.org/2011/10/windows-disable-usb-power-saving-disableselectivesuspend/
New-ItemProperty -Path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USB' -Name 'DisableSelectiveSuspend' -PropertyType DWORD -Value 1 -Force