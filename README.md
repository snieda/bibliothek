### library for fast creation of linux systems with console-enhancements

basic linux console developer tools and optional desktop applications and IDEs will be installed in one step.
tools like *tmux*, *mc*, *vim* will be configured with plugins. *vim* will be configured as full IDE for languages like java, pyhton and c.

several systems are supported: debian, arch, msys2(cygwin/windows), windows(scoop), suse (untested), fedora (untested)

#### installation

##### linux / msys2 (cygwin on windows)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  wget https://raw.githubusercontent.com/snieda/bibliothek/master/install-linux-dev-vm
  chmod +x install-linux-dev-vm
  ./install-linux-dev-vm
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

perhaps you have to set 'http_proxy' and 'https_proxy' before!

###### termux (android)

if you get an error like **BAD SYSTEM** on starting java, you should set:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
alias java="proot java"
alias javac="proot javac"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
##### start

start the downloaded script *./install-linux-dev-vm*

this will ask you for the desired tools:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##############################################################################
# install development-tools on linux (Thomas Schneider / 2016)
# 
# preconditions: linux or bsd system with package manager
# annotation   : on FreeBSD the bash is on: /usr/local/bin/bash
# tested on    : ubuntu, ghostbsd, termux, msys2
##############################################################################


 _____     ______     __   __  
/\  __-.  /\  ___\   /\ \ / /  
\ \ \/\ \ \ \  __\   \ \ \'/   
 \ \____-  \ \_____\  \ \__|   
  \/____/   \/_____/   \/_/    
                                                                                           
         ______     __  __     ______     __         __       
        /\  ___\   /\ \_\ \   /\  ___\   /\ \       /\ \      
        \ \___  \  \ \  __ \  \ \  __\   \ \ \____  \ \ \____ 
         \/\_____\  \ \_\ \_\  \ \_____\  \ \_____\  \ \_____\ 
          \/_____/   \/_/\/_/   \/_____/   \/_____/   \/_____/
                                                                                           

-------------------------------------------------------
Thomas Schneider / 2016 (refreshed 2020-02)
-------------------------------------------------------

-------------------------------------------------------
System : Linux myuser-mysystem 6.4.0-48-generic #52-Ubuntu SMP Thu Dez 24 10:58:49 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
User   : uid=1001(myuser) gid=1001(myuser) Gruppen=1001(myuser)
-------------------------------------------------------

Pckg Installer (apt,pacman,pkg,yum,yast,zypper): apt

Package Install Command                        : sudo apt install -y --ignore-missing 
Prepare (part,format) new disc /dev/sda (yes|N): 
Create new user (empty for current) with name  : 
============ System and VirtualBox informations ============
System upgrade                           (Y|n) : 
Linux System Bit-width (32|64)                 : 64
Termux Terminal Emulator System addons   (Y|n) : 
Unsecure (TimeServer:ntp, WinFS:samba)   (y|N) : 
Virtualbox Guest additions Version             : 5.1.6
Antiviren/Trojaner (clamav, rkhunter)    (Y|n) : 
Connect to a Network Domain                    : 
Mount network-drive on IP                      : 
Clone GIT Repository                           : 
================== development IDE+Tools ====================
Install open java8                       (Y|n) : 
Install graalvm java8 community          (Y|n) : 20.0.0
Install nodejs                           (Y|n) : 
Install python3.x+anaconda3            Version : 5.3.0
Install resilio sync (data sync)         (y|N) : 
Console System only                      (Y|n) : n
===================== XWindows Desktops =====================
Fluxbox (~5MB)                           (Y|n) : 
LXDE Desktop (~250MB)                    (Y|n) : 
Install wine (~400MB)                    (Y|n) : 
================ Standard Desktop Applications ===============
Install firefox                         (Y|n)  : 
Install libreoffice                     (Y|n)  : 
Install vlc                             (Y|n)  : 
Install citrix-workspace-app            (Y|n)  : 
Install virtual box                     (Y|n)  : 
Install gparted                         (Y|n)  : 
======================= Desktop IDEs ========================
Install java8 + netbeans 8.2             (Y|n) : 
Install visual studio code (~40MB)       (Y|n) : 
Install eclipse (~300MB)                 (Y|n) : 2019-09
Install fman (Ctrl+p filemanager)        (Y|n) : 
Install sublimetext+python-plugins       (Y|n) : 
Install squirrel (sql)                   (Y|n) : 
>>>>>> !!! START INSTALLATION ? <<<<<<  (Y|n)  : 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#### windows

##### installation

open a powershell console:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  wget https://raw.githubusercontent.com/snieda/bibliothek/master/install-win-scoop-dev.ps1
  install-win-scoop-dev.ps1
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
