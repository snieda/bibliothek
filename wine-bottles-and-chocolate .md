# Using Windows with Chocoloate through Wine and Bottles

* Gitlab Doc For Wine: https://gitlab.winehq.org/wine/wine/-/wikis/Debian-Ubuntu
* Wine Tricks Providing a Repository: "sudo apt install winetricks" or "sudo winetricks --self-update" 
* Wine-Bottles: https://usebottles.com/
* PCWelt Wine Article: https://www.pcwelt.de/article/2210434/windows-programme-mit-wine-unter-linux-nutzen.html
* Bottles (includes wine): 
* Powershell/Chocolate for Wine: https://github.com/PietJankbal/Chocolatey-for-wine
* (Old Powershell Wrapper): https://github.com/PietJankbal/powershell-wrapper-for-wine?tab=readme-ov-file
* WineGet: https://wineget.pages.dev/packages
* Jdk17 for Windows: https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html
* Call Powershell Script .ps1 with Bypass: powershell.exe -NoProfile -ExecutionPolicy Bypass ".\demo.ps1"
* To see a system information: sysinfo

## Configuring Wine through Bottles

* Create New Bottles Environment for Applications
* Bottles -> Preferences -> Tab:Runner -> <Newest Wine Version: Kron4Ek-Wine-10.8-amd64> -> Download 
* Preferences  -> Runner -> <Switch from soda-9-0-1 to kron4ek-wine-10.8-amd64>
* Dependencies -> DON'T INSTALL ANY ESSENTIALS like "d3dx11, dotnetcoredesktop9, mono, gecko, powershell-core, powershell"
* Extract and Copy Chocolatey-For-Wine to Wine-Bottles User Folder: ~/.var/app/com.usebottles.bottles/data/bottles/bottles/<Bottles-Env-Name>/drive_c/users/ts/Downloads
* Run Windows Explorer (File Manager) and doubleclick on ChoCinstaller_0.5a.751.exe
* In Bottles click on "change start options" on program entry "pwsh". add arguments: " -NoProfile -ExecutionPolicy Bypass" 

## Using Chocolatey

* Chocolatey Packages: https://community.chocolatey.org/packages
* DON'T: choco upgrade Chocolatey
* choco install openjdk17
    * setx JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.14.7-hotspot
    * setx PATH=%PATH%;%JAVA_HOME%\bin
* choco install chocolatey-core.extension wget (curl -> ERROR) git openjdk17 fzf mc far ripgrep vim firefox lapce doom4-death-foretold(https://freedoom.github.io/download.html) tv-browser microsoft-edge
* not working: officeproplus2013 office2019proplus skype microsoft-teams sauerbraten

## After Restart

* powershell.exe can be found in: C:\windows\syswow64\WindowsPowerShell\v1.0
    * only startable through explorer.exe (windows file manager) or fman
    * full path: ~/.var/app/com.usebottles.bottles/data/bottles/$MYBOTTLE/drive_c/windows/syswow64/WindowsPowerShell/v1.0/powershell.exe
* in windows title click on plus-symbol selecting "Chocolatey (Admin)"

## Fazit

* Could install a powershell with correct encoding and colors (only startable through filemanager (explorer or fman))
* Could install : a lot of system apps, known from linux ;-) and openjdk17
* Could NOT install/run any microsoft office/skype/teams (edge was installed but is not runnable)
* using sys-wine-10.0 and chocolatey upgrade: on all others there came error:
    * ...not installed. An error occurred during installation:
     Environment variable name cannot contain equal character.

### Some Notes

* I did a winetricks --self-update
* I added some Essentials....
* you can download with wget and install: fman, broot (great file manager), micro (editor)
* with filemanager fman your are much more efficient as with ms explorer
* use lapce instead of notepad or notepad++
