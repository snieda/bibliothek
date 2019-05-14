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
echo "Thomas Schneider / 2016 (refreshed 2018-11)"
echo -------------------------------------------------------
echo

INST="sudo apt install -y --ignore-missing"
apt install sudo > /dev/null #on minimized systems no sudo is available - you have to be root to install it!
DO_FORMAT=no

read -p  "Prepare (part, format) new disc /dev/sda (yes|N): " DO_FORMAT
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
if [ "$IP1" != "" ]; then
	sudo adduser --disabled-password --gecos "" dev
	sudo usermod -aG sudo dev
	sudo login -f dev
fi

echo "================ System and VirtualBox informations ================"

read -p  "System upgrade                           (Y|n) : " INST_UPGRADE
read -ep "Linux System Bit-width (32|64)                 : " -i "64" BITS
read -ep "Virtualbox Version                             : " -i 5.1.6 VB_VERSION
read -p  "Mount network-drive on IP (+git-clone)         : " IP1
if [ "$IP1" != "" ]; then
    read -p "Mount network-drive on PATH                   : " SHARE1
    read -p "Mount network-drive on USER                   : " USER1
    read -p "Clone GIT Repository                          : " REPO
    if [ "$REP0" != "" ]; then
        read -p "Git Project Name                             : " PRJ
    fi
fi
read -p  "Console System only                      (Y|n) : " CONSOLE_ONLY
if [ "$CONSOLE_ONLY" == "n" ]; then
	read -p  "LXDE Desktop (~250MB)                    (Y|n) : " INST_LXDE
	echo    "================ Standard Office Applications ================"
	read -p "Install firefox                         (Y|n) : " INST_FIREFOX
	read -p "Install libreoffice                     (Y|n) : " INST_LIBREOFFICE
	read -p "Install vlc                             (Y|n) : " INST_VLC
fi
echo     "================ development IDE+Tools ================"
read -p "Install java8                           (Y|n) : " INST_JAVA
if [ "$CONSOLE_ONLY" == "n" ]; then
	read -p "Install java8 + netbeans 8.2            (Y|n) : " INST_NETBEANS
	read -p "Install visual studio code (~40MB)      (Y|n) : " INST_VSCODE
	read -p "Install eclipse 2018-09 (~300MB)        (Y|n) : " INST_ECLIPSE
	read -p "Install fman (Ctrl+p filemanager)       (Y|n) : " INST_FMAN
	read -p "Install sublimetext+python-plugins      (Y|n) : " INST_SUBLIMETEXT
	read -p "Install squirrel (sql)                  (Y|n) : " INST_SQUIRREL
fi
read -p "Install python3.x+anaconda 5.3          (Y|n) : " INST_PYTHON_ANACONDA
read -p "Install resilio sync (data sync)        (y|N) : " INST_RESILIO_SYNC

echo "do some updates..."
sudo apt update
if [ "$INST_UPGRADE" != "n" ]; then
	sudo apt -y upgrade
fi

echo "install system tools (~83MB)..."
for i in mc tree ytree htop git mupdf antiword fim zip rar p7zip tmux; do $INST $i; done

echo "install console text tools..."
for i in vim ne dos2unix poppler-utils docx2txt catdoc colordiff icdiff colorized-logs kbtin pv bar ripgrep; do $INST $i; done

echo "install networking tools..."
for i in nmap git curl wget openssh-server openvpn links2 w3m tightvncserver; do $INST $i; done

if [ "$CONSOLE_ONLY" == "n" ]; then
	echo "echo install xwin-system tools"
	$INST xclip xcompmgr conky abiword 
fi

#echo "Hetzner NTP WARNING: enables DDOS attacks!"
#$INST ntp
#echo "CIFS contains main server of SAMBA-4: smbd, nmbd (network access on windows filesystem and printers)"
#$INST cifs-utils

echo "tool configurations (mc, tmux, etc...)
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.tmux.conf > .tmux.conf
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/mc/ini > .config/mc/ini
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/mc/panels.ini > .config/mc/panels.ini

echo "vim plugin dependencies"
sudo apt make cmake gcc silversearcher-ag exuberant-ctags
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.vimrc > .vimrc
#wget https://github.com/ervandew/eclim/releases/download/2.8.0/eclim_2.8.0.bin
#chmod a+x eclim_2.8.0.bin

echo "python3"
$INST python3 python3-pip flake8
pip install autopep8 pudb

echo "installing all plugins for our vim-ide"
vim +'PlugInstall --sync' +qa

if [ "$INST_LXDE" != "n" ]; then
	echo "install lxde..."
	$INST lxde lxde-core
fi

if [ "$VB_VERSION" != "" ]; then
	echo "install virtualbox guest additions"
	#$INST virtualbox-guest-utils virtualbox-guest-x11
	$INST linux-headers-$(uname -r) build-essential dkms
	wget -nc http://download.virtualbox.org/virtualbox/$VB_VERSION/VBoxGuestAdditions_$VB_VERSION.iso
	sudo mkdir /media/VBoxGuestAdditions
	sudo mount -o loop,ro VBoxGuestAdditions_$VB_VERSION.iso /media/VBoxGuestAdditions
	sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
	rm VBoxGuestAdditions_$VB_VERSION.iso
	sudo umount /media/VBoxGuestAdditions
	sudo rmdir /media/VBoxGuestAdditions
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
#	cd ..
	$INST libreoffice-common
fi

if [ "$INST_VLC" != "n" ]; then
	echo "install vlc..."
	$INST vlc-nox
fi

if [ "$INST_NETBEANS" != "n" ]; then
    echo "install java+netbeans..."
    # wget -nc http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    wget -nc --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk-nb/8u111-8.2/jdk-8u111-nb-8_2-linux-x$BITS.sh
    sudo bash jdk-8u111-nb-8_2-linux-x$BITS.sh --silent &
    jdk-8u111-nb-8_2-linux-x$BITS.sh
    wget http://plugins.netbeans.org/download/plugin/3380
fi

if [ "$INST_JAVA" != "n" ]; then
    echo "install java+netbeans..."
    # wget -nc http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    wget -nc --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x$BITS.tar.gz
	sudo tar xfz jdk-8u191-linux-x$BITS.tar.gz
	sudo ln -s java jdk1.8.0_191
	ls -l /usr/local/sbin/
fi

if [ "$INST_VSCODE" != "n" ]; then
    echo "install visual studio code..."
	# old version (try both...)
	sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
	
	# new version (try both...)
	# Install key
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	# Install repo
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	# Update apt-get
	sudo apt update
	# Install
	$INST code # or code-insiders
	mkdir workspace
	echo "https://gist.github.com/snieda/0063c25f13cf8c9d5021941ca57ac895" > workspace/settings-sync-gist.txt 
	code --install-extension Shan.code-settings-sync -a workspace &
fi

if [ "$INST_ECLIPSE" != "n" ]; then
    echo "install eclipse..."
	wget -nc http://ftp.fau.de/eclipse/technology/epp/downloads/release/2018-09/R/eclipse-jee-2018-09-linux-gtk-x86_64.tar.gz
	sudo tar xfz eclipse-jee-2018-09-linux-gtk-x86_$BITS.tar.gz
	sudo ln -s /eclipse/eclipse /usr/local/sbin/eclipse
	ls -l /usr/local/sbin/
fi

if [ "$INST_FMAN" != "n" ]; then
	echo "install fman..."
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 9CFAF7EB
	sudo apt-get install apt-transport-https
	echo "deb [arch=amd64] https://fman.io/updates/ubuntu/ stable main" | sudo tee /etc/apt/sources.list.d/fman.list
	sudo apt-get install fman
fi

if [ "$INST_SUBLIMETEXT" != "n" ]; then
	echo "install sublime-text + plugins..."
	wget -nc https://download.sublimetext.com/sublime-text_build-3126_amd$BITS.deb
	sudo dpkg-deb -x sublime-text_build-3126_amd$BITS.deb /
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
	#sudo apt -y install python3 python3-pip python3-nose
	$INST python-pip

    wget -nc https://repo.continuum.io/archive/Anaconda3-5.3.0-Linux-x86_$BITS.sh
    #sudo rm -rf anaconda3
    # the bash script provides -b for non-interactive - but with unwanted defaults
    echo -e "\n yes\n\nyes\n" | bash Anaconda3-5.3.0-Linux-x86_$BITS.sh
    rm Anaconda3-5.3.0-Linux-x86_$BITS.sh
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

if [ "$IP1" != "" ]; then
    echo "domain"
    wget -nc http://download.beyondtrust.com/PBISO/8.0.0.2016/linux.deb.x$BITS/pbis-open-8.0.0.2016.linux.x86_$BITS.deb.sh
    chmod +x pbis-open-8.0.0.2016.linux.x86_$BITS.deb.sh
    sudo ./pbis-open-8.0.0.2016.linux.x86_$BITS.deb.sh
    domainjoin-cli join $DOMAIN $DOMAIN_USER

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
    cd workspace/$PRJ
    subl ./
fi

if [ "$VB_VERSION" != "" ]; then
	echo "package the box..."
	sudo apt-get clean
	sudo dd if=/dev/zero of=/EMPTY bs=1M
	sudo rm -f /EMPTY
	#sudo shutdown -h now
fi

echo "PATH='$HOME/bin:$HOME/.local/bin:$JAVA_HOME/bin:$PATH'" >> .profile
echo 'export DISPLAY=0:0' >> .profile
