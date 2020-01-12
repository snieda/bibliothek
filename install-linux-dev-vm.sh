#!/bin/bash
clear
cat <<EOM
##############################################################################
# install development-tools on linux (Thomas Schneider / 2016)
# 
# preconditions: debian 64bit system
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
                                                                                           

EOM

# ----------------------------------------------------
# system preparations
# ----------------------------------------------------
echo -------------------------------------------------------
echo "Thomas Schneider / 2016 (refreshed 2020-01)"
echo -------------------------------------------------------
echo

read -ep "Package Installer (apt,pacman,pkg,yast)        : " -i "apt" PKG

$PKG install sudo > /dev/null #on minimized systems no sudo is available - you have to be root to install it!
sudo -h > /dev/null #only to check, if available
if [ "$?" == "0" ]; then
	SUDO="sudo"
fi
echo

INST="$SUDO $PKG install -y --ignore-missing $*"
DO_FORMAT=no

read -ep "Package Install Command                        : " -i "$INST" INST

if [ "$SUDO" == "sudo" ]; then
	read -p  "Prepare (part,format) new disc /dev/sda (yes|N): " DO_FORMAT
	if [ "$DO_FORMAT" == "yes" ]; then
	    echo -e "o\nn\np\n\n\n\nw" | sudo fdisk /dev/sda
	    sudo mkfs.ext4 -F -L "casper-rw" /dev/sda
	    echo "Please restart the VM to include the formatted drive!"
	    read -p "Restart now (Y|n) ? " RESTART_NOW
	    if [ "$RESTART_NOW" == "" ] || [ "$RESTART_NOW" == "y" ]; then
		sudo halt --reboot
	    fi
	    exit
	fi

	read -p  "Create new user (empty for current) with name  : " DEV
	if [ "$DEV" != "" ]; then
		sudo adduser --disabled-password --gecos "" $DEV
		sudo usermod -aG sudo $DEV
		sudo login -f $DEV
	fi
fi
echo "================ System and VirtualBox informations ================"

read -p  "System upgrade                           (Y|n) : " INST_UPGRADE
read -ep "Linux System Bit-width (32|64)                 : " -i "64" BITS
read -ep "Virtualbox Guest additions Version             : " -i 5.1.6 VB_VERSION
read -p  "Antiviren/Trojaner (clamav, rkhunter)    (Y|n) : " INST_ANTIVIR
read -p  "Connect to a Network Domain                    : " DOMAIN
if [ "$DOMAIN" != "" ]; then
    read -p "Connect to Domain with user                    : " DOMAIN_USER
fi
read -p  "Mount network-drive on IP                      : " IP1
if [ "$IP1" != "" ]; then
    read -p "Mount network-drive on PATH                    : " SHARE1
    read -p "Mount network-drive on USER                    : " USER1
fi
read -p  "Clone GIT Repository                           : " REPO
if [ "$REPO" != "" ]; then
	read -p "Git Project Name                               : " PRJ
fi
read -p  "Console System only                      (Y|n) : " CONSOLE_ONLY
if [ "$CONSOLE_ONLY" == "n" ]; then
	read -p  "Fluxbox (~5MB)                           (Y|n) : " INST_FLUX
	read -p  "LXDE Desktop (~250MB)                    (Y|n) : " INST_LXDE
	read -p  "Install wine (~400MB)                    (Y|n) : " INST_WINE
	echo    "================ Standard Office Applications ================"
	read -p  "Install firefox                         (Y|n)  : " INST_FIREFOX
	read -p  "Install libreoffice                     (Y|n)  : " INST_LIBREOFFICE
	read -p  "Install vlc                             (Y|n)  : " INST_VLC
	read -p  "Install citrix-workspace-app            (Y|n)  : " INST_CITRIX
	read -p  "Install virtual box                     (Y|n)  : " INST_VIRTUALBOX
	read -p  "Install gparted                         (Y|n)  : " INST_GPARTED
fi
echo     "================ development IDE+Tools ================"
read -p "Install java8                           (Y|n) : " INST_JAVA
read -p "Install nodejs                          (Y|n) : " INST_NODEJS
if [ "$CONSOLE_ONLY" == "n" ]; then
	read -p "Install java8 + netbeans 8.2            (Y|n) : " INST_NETBEANS
	read -p "Install visual studio code (~40MB)      (Y|n) : " INST_VSCODE
	read -p "Install eclipse 2019-09 (~300MB)        (Y|n) : " INST_ECLIPSE
	read -p "Install fman (Ctrl+p filemanager)       (Y|n) : " INST_FMAN
	read -p "Install sublimetext+python-plugins      (Y|n) : " INST_SUBLIMETEXT
	read -p "Install squirrel (sql)                  (Y|n) : " INST_SQUIRREL
fi
read -p "Install python3.x+anaconda 5.3          (Y|n) : " INST_PYTHON_ANACONDA
read -p "Install resilio sync (data sync)        (y|N) : " INST_RESILIO_SYNC

read -p ">>>>>> !!! START INSTALLATION ? <<<<<<  (Y|n) : " START
if [ "$START" == "n" ]; then
	exit
fi
echo "do some updates..."
$SUDO $PKG update
if [ "$INST_UPGRADE" != "n" ]; then
	$SUDO $PKG -y upgrade
fi

echo "install system tools (~83MB)..."
for i in mc tree ytree htop git mupdf antiword fim zip rar p7zip tmux exfat-fuse; do $INST $i; done

echo "install console text tools..."
for i in vim ne dos2unix poppler-utils docx2txt catdoc colordiff icdiff colorized-logs kbtin pv bar ripgrep expect; do $INST $i; done

echo "install networking tools..."
for i in nmap git curl wget openssh openssh-server openvpn gnupg links2 w3m tightvncserver, tigervnc; do $INST $i; done

echo "install printer drivers..."
$INST printer-driver-cups-pdf

if [ "$CONSOLE_ONLY" == "n" ]; then
	echo "echo install xwin-system tools"
	$INST x11-repo # only for termux
	for i in xclip xcompmgr conky abiword pm-utils; do $INST $i; done
fi

#echo "Hetzner NTP WARNING: enables DDOS attacks!"
#$INST ntp
#echo "CIFS contains main server of SAMBA-4: smbd, nmbd (network access on windows filesystem and printers)"
#$INST cifs-utils

echo "tool configurations (mc, tmux, etc...)"
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.tmux.conf > .tmux.conf
mkdir -p .config/mc
mkdir -p .termux
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/mc/ini > .config/mc/ini
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/mc/panels.ini > .config/mc/panels.ini
curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash > shell/keybindings.bash
curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash > shell/completion.bash
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.termux/termux.properties > .termux/termux.properties
echo "alias ll='ls -alF'" >> .profile

if [ "$INST_ANTIVIR" != "n" ]; then
	echo "install antiviren (clam-av, rk-hunter..."
	$INST clamav rkhunter
fi

echo "vim plugin dependencies"
for i in make cmake gcc silversearcher-ag exuberant-ctags; do $INST $i; done
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.vimrc > .vimrc
#wget https://github.com/ervandew/eclim/releases/download/2.8.0/eclim_2.8.0.bin
#chmod a+x eclim_2.8.0.bin

echo "python3"
for i in python python-pip python3 python3-pip flake8 autopep8 pudb; do $INST $i; done
pip install -U pip

echo "installing all plugins for our vim-ide"
vim +'PlugInstall --sync' +qa

if [ "$INST_LXDE" != "n" ]; then
	echo "install lxde..."
	$INST lxde lxde-core
fi

if [ "$INST_FLUX" != "n" ]; then
	echo "install flux..."
	$INST fluxbox
	mkdir -p .vnc
	curl https://raw.githubusercontent.com/snieda/bibliothek/master/.vnc/xstartup > .vnc/xstartup
fi

if [ "$INST_WINE" != "n" ]; then
	echo "install wine-hq..." # only one of the is available!
	for i in  wine-hq wine-stable wine; do $INST $i; done
fi

if [ "$INST_VIRTUALBOX" != "n" ]; then
	echo "install virtualbox..."
	$INST virtualbox
fi

if [ "$INST_GPARTED" != "n" ]; then
	echo "install gparted..."
	$INST gparted
fi

if [ "$VB_VERSION" != "" ]; then
	echo "install virtualbox guest additions"
	#$INST virtualbox-guest-utils virtualbox-guest-x11
	$INST linux-headers-$(uname -r) build-essential dkms
	wget -nc http://download.virtualbox.org/virtualbox/$VB_VERSION/VBoxGuestAdditions_$VB_VERSION.iso
	$SUDO mkdir /media/VBoxGuestAdditions
	$SUDO mount -o loop,ro VBoxGuestAdditions_$VB_VERSION.iso /media/VBoxGuestAdditions
	$SUDO sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
	rm VBoxGuestAdditions_$VB_VERSION.iso
	$SUDO umount /media/VBoxGuestAdditions
	$SUDO rmdir /media/VBoxGuestAdditions
fi

if [ "$INST_FIREFOX" != "n" ]; then
	echo "install firefox..."
	$INST firefox
fi

if [ "$INST_LIBREOFFICE" != "n" ]; then
    echo "install libreoffice..."
#	wget -nc https://www.libreoffice.org/donate/dl/deb-x86_64/6.1.2/de/LibreOffice_6.1.2_Linux_x86-64_deb.tar.gz
#	tar -xvf LibreOffice_6.1.2_Linux_x86-64_deb.tar.gz
#	cd debs
#	sudo dpkg -i *.deb
#	sudo apt-get -f install
#	cd ..
	$INST libreoffice-common
fi

if [ "$INST_CITRIX" != "n" ]; then
    echo "install citrix workspace app..."
    wget https://downloads.citrix.com/15918/linuxx64-19.3.0.5.tar.gz?__gda__=1560365066_f53cf2cdbacbfbb07d9baecb77691004
    $SUDO dpkg -i *.deb
    $SUDO apt-get -f install
fi


if [ "$INST_VLC" != "n" ]; then
	echo "install vlc..."
	$INST vlc-nox vlc
fi

if [ "$INST_NETBEANS" != "n" ]; then
    echo "install java+netbeans..."
    # wget -nc http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    wget -nc --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk-nb/8u111-8.2/jdk-8u111-nb-8_2-linux-x$BITS.sh
    $SUDO bash jdk-8u111-nb-8_2-linux-x$BITS.sh --silent &
    jdk-8u111-nb-8_2-linux-x$BITS.sh
    wget http://plugins.netbeans.org/download/plugin/3380
fi

if [ "$INST_JAVA" != "n" ]; then
    echo "install java openjdk-8-jdk..."
    # wget -nc http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    #wget -nc --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn/java/jdk/8u211-b12/478a62b7d4e34b78b671c754eaaf38ab/jdk-8u211-linux-x64.tar.gz
	#sudo tar xfz jdk-8u191-linux-x$BITS.tar.gz
	#sudo ln -s java jdk1.8.0_191
	#ls -l /usr/local/sbin/
	echo "export JAVA_HOME=/usr" >> .profile
	echo "PATH=$JAVA_HOME/bin:$PATH" >> .profile
	$INST openjdk-8-jdk maven
	echo "call 'sudo update-alternatives --config java' to select/config the desired java"
	
	wget http://www-eu.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz
	tar -xf apache-maven-3.5.3-bin.tar.gz
	echo "export M2_HOME=$(pwd)/apache-maven >> .profile
	export MAVEN_HOME=$(pwd)/apache-maven >> .profile
	export PATH=${M2_HOME}/bin:${PATH} >> .profile
fi

if [ "$INST_NODEJS" != "n" ]; then
	$INST nodejs
fi

if [ "$INST_VSCODE" != "n" ]; then
    echo "install visual studio code..."
	# old version (try both...)
	$SUDO add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	$SUDO apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
	
	# new version (try both...)
	# Install key
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	$SUDO mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	# Install repo
	$SUDO sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	# Update apt-get
	$SUDO $PKG update
	# Install
	$INST code # or code-insiders
	mkdir workspace
	echo "https://gist.github.com/snieda/0063c25f13cf8c9d5021941ca57ac895" > workspace/settings-sync-gist.txt 
	code --install-extension alphabotsec.vscode-eclipse-keybindings --install-extension  danields761.status-bar-breadcrumb --install-extension  dgileadi.java-decompiler --install-extension  donjayamanne.githistory --install-extension  donjayamanne.javadebugger --install-extension  DotJoshJohnson.xml --install-extension  eamodio.gitlens --install-extension  faustinoaq.javac-linter --install-extension  felipecaputo.git-project-manager --install-extension  IBM.XMLLanguageSupport --install-extension  masonicboom.web-browser --install-extension  ms-python.python --install-extension  ms-vsts.team --install-extension  msjsdiag.debugger-for-chrome --install-extension  qub.qub-xml-vscode --install-extension  redhat.java --install-extension  Shan.code-settings-sync --install-extension  VisualStudioExptTeam.vscodeintellicode --install-extension  vscjava.vscode-java-debug --install-extension  vscjava.vscode-java-dependency --install-extension  vscjava.vscode-java-pack --install-extension  vscjava.vscode-java-test --install-extension  vscjava.vscode-maven --install-extension  yzhang.markdown-all-in-one -a workspace &
fi

if [ "$INST_ECLIPSE" != "n" ]; then
    echo "install eclipse..."
	wget -nc http://ftp.fau.de/eclipse/technology/epp/downloads/release/2019-09/R/eclipse-jee-2019-09-R-linux-gtk-x86_$BITS.tar.gz
	$SUDO tar xfz eclipse-jee-2019-09-R-linux-gtk-x86_$BITS.tar.gz
	$SUDO ln -s /eclipse/eclipse /usr/local/sbin/eclipse
	ls -l /usr/local/sbin/
fi

if [ "$INST_FMAN" != "n" ]; then
	echo "install fman..."
	#curl https://fman.io/download/thank-you?os=Linux&distribution=Ubuntu
	$SUDO apt-key adv --keyserver keyserver.ubuntu.com --recv 9CFAF7EB
	$INST apt-transport-https
	echo "deb [arch=amd64] https://fman.io/updates/ubuntu/ stable main" | $SUDO tee /etc/apt/sources.list.d/fman.list
	$INST fman
fi

if [ "$INST_SUBLIMETEXT" != "n" ]; then
	echo "install sublime-text + plugins..."
	wget -nc https://download.sublimetext.com/sublime-text_build-3126_amd$BITS.deb
	$SUDO dpkg-deb -x sublime-text_build-3126_amd$BITS.deb /
	rm sublime-text_build-3126_amd$BITS.deb
	# start sublime-text to create the directory structure
	subl
	wget  -nc https://packagecontrol.io/Package%20Control.sublime-package
	cp "Package Control".sublime-package ~/.config/sublime-text-3/"Installed Packages"
cat <<EOM >> ~/.config/sublime-text-3/Packages/User/"Package Control".sublime-settings
{
   "installed_packages":
    [
        "Anaconda",
        "AutoFileName",
        "Block Cursor Everywhere",
        "BracketHighlighter",
        "CursorRuler",
	"Diffy",
        "Git",
        "GitGutter",
        "Markdown Preview",
        "Open in Default Application",
        "Package Control",
        "PackageResourceViewer",
        "PyRefactor",
        "Python Breakpoints",
        "Python Flake8 Lint",
        "Python Improved",
        "SideBarEnhancements",
        "SublimeCodeIntel",
        "SublimeREPL",
        "SyncedSideBar",
        "Terminal",
    ]
}
EOM
fi

if [ "$INST_PYTHON_ANACONDA" != "n" ]; then
    echo "install python+anaconda..."
	#$SUDO $PKG -y install python3 python3-pip python3-nose
	$INST python-pip

    wget -nc https://repo.continuum.io/archive/Anaconda3-5.3.0-Linux-x86_$BITS.sh
    #sudo rm -rf anaconda3
    # the bash script provides -b for non-interactive - but with unwanted defaults
    echo -e "\n yes\n\nyes\n" | bash Anaconda3-5.3.0-Linux-x86_$BITS.sh
    rm Anaconda3-5.3.0-Linux-x86_$BITS.sh
    # upgrade all python modules
    pip list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U
fi

if [ "$INST_SQUIRREL" != "n" ]; then
	wget -nc https://sourceforge.net/projects/squirrel-sql/files/latest/download -O squirrel-sql-client.jar
fi

# ----------------------------------------------------
# additional terminal tools
# ----------------------------------------------------
mkdir bin

echo "installing Fuzzy Finder"
wget -nc https://github.com/junegunn/fzf/raw/master/install
mv install fzf-install.sh
chmod a+x fzf-install.sh
echo "yes\nyes\nyes\n\n" | ./fzf-install.sh

echo "installing micro editor"
#MICRO_DIR=micro-1.4.1
#wget -nc https://github.com/zyedidia/micro/releases/tag/v1.4.1/$MICRO_DIR-linux$BITS.tar.gz
#tar -xvf $MICRO_DIR-linux$BITS.tar.gz
#cp $MICRO_DIR/micro bin/
curl https://getmic.ro | bash
cp micro bin/

# ----------------------------------------------------
# user/project dependent installations
# ----------------------------------------------------

if [ "$INST_RESILIO_SYNC" == "y" ]; then
    echo "install/run bittorrent-sync. use localhost:8888 to configure it"
    wget -nc https://download-cdn.resilio.com/stable/linux-x$BITS/resilio-sync_x$BITS.tar.gz
    tar -xf resilio-sync_x$BITS.tar.gz
    ./rslsync
fi

if [ "$DOMAIN" != "" ]; then
    echo "domain"
    wget -nc http://download.beyondtrust.com/PBISO/8.0.0.2016/linux.deb.x$BITS/pbis-open-8.0.0.2016.linux.x86_$BITS.deb.sh
    chmod +x pbis-open-8.0.0.2016.linux.x86_$BITS.deb.sh
    sudo ./pbis-open-8.0.0.2016.linux.x86_$BITS.deb.sh
    domainjoin-cli join $DOMAIN $DOMAIN_USER
fi

if [ "$IP1" != "" ]; then
    echo "connect network share drives"
    IP1=${IP1:-//XX.XX.XX.XX}
    USER1=${USER1:-XX}
    SHARE1=${SHARE1:-XXXX}

    sudo mkdir /media/$SHARE1
    echo "sudo mount -t cifs -o username=$USER1,gid=$USER,uid=$USER $IP1/$SHARE1 /media/$SHARE1/" > bin/mount-$SHARE1.sh
    chmod a+x bin/mount-$SHARE1
    bin/mount-$SHARE1
fi

if [ ! -f ~/.ssh/id_rsa.pub ]; then 
	echo "prepare ssh key to be copied to server machines"
	echo -e "\n\n\n" | ssh-keygen -t rsa
	cat ~/.ssh/id_rsa.pub | xclip -sel clip
fi

if [ "$REPO" != "" ]; then
    echo "get git projects"
    REPO=${REPO:-XXXX}
    PRJ=${PRJ:-XXX}
    #git clone https://bitbucket.org/$REPO/$PRJ.git workspace/$PRJ
    git clone $REPO workspace/$PRJ
    pip install -r workspace/$PRJ/requirements.txt
    #cd workspace/$PRJ
    mvn -f workspace/$PRJ/pom.xml clean install
    #subl ./
fi

if [ "$VB_VERSION" != "" ]; then
	echo "package the box..."
	sudo apt-get clean
	sudo dd if=/dev/zero of=/EMPTY bs=1M
	sudo rm -f /EMPTY
	#sudo shutdown -h now
fi

echo "PATH='$HOME/bin:$HOME/.local/bin:$JAVA_HOME/bin:$PATH'" >> .profile
if [ "$CONSOLE_ONLY" == "n" ]; then
	echo "not setting DISPLAY in console mode"
else
	echo 'export DISPLAY=0:0' >> .profile
fi
# reload profile
cd
source .profile
