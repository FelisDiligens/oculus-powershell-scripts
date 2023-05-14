# PowerShell scripts for Oculus

## Usage
1. Open PowerShell as admin (for some scripts).
2. Use scripts as shown below:

```powershell
PS > .\EnableASW.ps1
PS > .\DisableASW.ps1

PS > .\InstallHomeless.ps1
PS > .\UninstallHomeless.ps1

PS > .\InstallOpenComposite.ps1 -Path "C:\Program Files (x86)\Steam\steamapps\common\Beat Saber"
PS > .\UninstallOpenComposite.ps1 -Path "C:\Program Files (x86)\Steam\steamapps\common\Beat Saber"

PS > .\SetSupersampling.ps1 -Density 1.5

PS > .\StartMirror
PS > .\StartMirror -Width 1920 -Height 1080 -FOVMultiplier 1.5

PS > .\StopOculusRuntime.ps1

PS > .\OptimizePowerSettings.ps1

PS > .\EnableOculusServicesAutoStart.ps1
PS > .\DisableOculusServicesAutoStart.ps1
```

## Will there be a GUI?
No, sorry. Check out [Oculus Tray Tool by ApollyonVR](https://forums.oculusvr.com/community/discussion/47247/oculus-traytool-supersampling-profiles-hmd-disconnect-fixes-hopefully/p1), if you feel uncomfortable with the shell.

## What is Homeless?
Homeless replaces Oculus Home and just renders a blank environment, using minimal resources.
My script also sets the background to black.

Please read this: https://www.reddit.com/r/oculus/comments/8uf1sm/oculushomeless_use_dash_without_home_20/

## What is OpenComposite?
OpenComposite is an implementation of SteamVR's API - OpenVR, forwarding calls directly to the Oculus runtime.
Think of it as a backwards version of ReVive, for the Rift.

This allows you to play SteamVR-based games on an Oculus Rift as though they were native titles, without
the use of SteamVR!

Please read this: https://gitlab.com/znixian/OpenOVR/blob/master/README.md

### Which path to give to the script?
The script looks recursively (in subdirectories) for "openvr_api.dll" files and replaces them.
So it doesn't matter if the directory doesn't contain the dll file.

Don't worry, it renames the original to "openvr_api_org.dll". It's not permanent.
Just run the uninstallation script and it'll be reverted.

### Which architecture should I use?
The script is able to detect the architecture needed. You can override it, though.

> "Be sure to get the matching platform - if the game is a 32-bit game you need
the 32-bit DLL, even though you're probably running a 64-bit computer. Simple solution: if one doesn't work, try the other."

If you aren't sure, just use "auto".

Parameter -Arch: "x64", "x86", or "auto" (default)

## What is ASW?
The Rift operates at 90Hz (Rift S at 80Hz btw). With ASW, when an application fails to submit frames at 90Hz (80Hz), the Rift runtime drops the application down to 45Hz (40Hz) with ASW providing each intermediate frame.
ASW applies animation detection, camera translation, and head translation to previous frames in order to predict the next frame. As a result, motion is smoothed and applications can run on lower performance hardware.
By default, ASW is enabled for all supported Rift versions.

Please read this: https://developer.oculus.com/documentation/pcsdk/latest/concepts/asynchronous-spacewarp/

ASW 2.0 update post: https://www.oculus.com/blog/introducing-asw-2-point-0-better-accuracy-lower-latency/?locale=de_DE

### Why would I want to disable it?
It basically locks your FPS to 45/40 and ASW is making it even worse (distorted intermediate frames).
At least in fast paced games like Beat Saber.

It also can't be disabled from the user interface.
You'd have to run the Debug Tool and disable it there everytime you want to play.
Or you could just run my script.