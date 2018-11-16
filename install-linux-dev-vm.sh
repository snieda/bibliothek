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

echo "================ System and VirtualBox informations ================"

read -p "System upgrade                           (Y|n) : " INST_UPGRADE
read -ep "Linux System Bit-width (32|64)                : " -i "64" BITS
read -p "LXDE Desktop (~250MB)                    (Y|n) : " INST_LXDE
read -ep "Virtualbox Version                            : " -i 5.1.6 VB_VERSION
read -p "Mount network-drive on IP (+git-clone)         : " IP1
if [ "$IP1" != "" ]; then
    read -p "Mount network-drive on PATH                   : " SHARE1
    read -p "Mount network-drive on USER                   : " USER1
    read -p "Clone GIT Repository                          : " REPO
    if [ "$REP0" != "" ]; then
        read -p "Git Project Name                             : " PRJ
    fi
fi

echo    "================ Standard Office Applications ================"
read -p "Install firefox                         (Y|n) : " INST_FIREFOX
read -p "Install libreoffice                     (Y|n) : " INST_LIBREOFFICE
read -p "Install vlc                             (Y|n) : " INST_VLC

echo     "================ development IDE+Tools ================"
read -p "Install java8 + netbeans 8.2            (Y|n) : " INST_NETBEANS
read -p "Install java8                           (Y|n) : " INST_JAVA
read -p "Install visual studio code (~40MB)      (Y|n) : " INST_VSCODE
read -p "Install eclipse 2018-09 (~300MB)        (Y|n) : " INST_ECLIPSE
read -p "Install sublimetext+python-plugins      (Y|n) : " INST_SUBLIMETEXT
read -p "Install python3.x+anaconda 5.3          (Y|n) : " INST_PYTHON_ANACONDA
read -p "Install squirrel (sql)                  (Y|n) : " INST_SQUIRREL
read -p "Install resilio sync (data sync)        (y|N) : " INST_RESILIO_SYNC

echo "do some updates..."
sudo apt-get update
if [ "$INST_UPGRADE" != "n" ]; then
	sudo apt-get -y upgrade
fi

echo "install system tools (~83MB)..."
sudo apt-get -y install mc tree ytree htop git conky mupdf abiword antiword xclip fim cifs-utils  rar p7zip ntp xcompmgr tmux

echo "install console text tools..."
sudo apt-get -y install vim ne dos2unix poppler-utils docx2txt catdoc colordiff icdiff colorized-logs kbtin pv bar

echo "install networking tools..."
sudo apt-get -y install nmap git curl wget openssh-server openvpn links2 w3m tightvncserver

if [ "$INST_LXDE" != "n" ]; then
    echo "install lxde..."
	sudo apt install -y lxde lxde-core
fi

if [ "$VB_VERSION" != "" ]; then
	echo "install virtualbox guest additions"
	#sudo apt-get -y install virtualbox-guest-utils virtualbox-guest-x11
	sudo apt-get -y install linux-headers-$(uname -r) build-essential dkms
	wget http://download.virtualbox.org/virtualbox/$VB_VERSION/VBoxGuestAdditions_$VB_VERSION.iso
	sudo mkdir /media/VBoxGuestAdditions
	sudo mount -o loop,ro VBoxGuestAdditions_$VB_VERSION.iso /media/VBoxGuestAdditions
	sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
	rm VBoxGuestAdditions_$VB_VERSION.iso
	sudo umount /media/VBoxGuestAdditions
	sudo rmdir /media/VBoxGuestAdditions
fi

if [ "$INST_FIREFOX" != "n" ]; then
    echo "install firefox..."
	sudo apt install -y firefox
fi

if [ "$INST_LIBREOFFICE" != "n" ]; then
    echo "install libreoffice..."
#	wget https://www.libreoffice.org/donate/dl/deb-x86_64/6.1.2/de/LibreOffice_6.1.2_Linux_x86-64_deb.tar.gz
#	tar -xvf LibreOffice_6.1.2_Linux_x86-64_deb.tar.gz
#	cd debs
#	sudo dpkg -i *.deb
#	cd ..
	sudo apt install libreoffice-common
fi

if [ "$INST_VLC" != "n" ]; then
    echo "install vlc..."
	sudo apt install -y vlc-nox
fi

if [ "$INST_NETBEANS" != "n" ]; then
    echo "install java+netbeans..."
    # wget http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk-nb/8u111-8.2/jdk-8u111-nb-8_2-linux-x$BITS.sh
    sudo bash jdk-8u111-nb-8_2-linux-x$BITS.sh --silent &
    jdk-8u111-nb-8_2-linux-x$BITS.sh
    wget http://plugins.netbeans.org/download/plugin/3380
fi

if [ "$INST_JAVA" != "n" ]; then
    echo "install java+netbeans..."
    # wget http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x$BITS.tar.gz
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
	sudo apt-get update
	# Install
	sudo apt-get install code # or code-insiders
fi

if [ "$INST_ECLIPSE" != "n" ]; then
    echo "install eclipse..."
	wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/2018-09/R/eclipse-jee-2018-09-linux-gtk-x86_64.tar.gz
	sudo tar xfz eclipse-jee-2018-09-linux-gtk-x86_$BITS.tar.gz
	sudo ln -s /eclipse/eclipse /usr/local/sbin/eclipse
	ls -l /usr/local/sbin/
fi

if [ "$INST_SUBLIMETEXT" != "n" ]; then
	echo "install sublime-text + plugins..."
	wget https://download.sublimetext.com/sublime-text_build-3126_amd$BITS.deb
	sudo dpkg-deb -x sublime-text_build-3126_amd$BITS.deb /
	rm sublime-text_build-3126_amd$BITS.deb
	# start sublime-text to create the directory structure
	subl
	wget  https://packagecontrol.io/Package%20Control.sublime-package
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
	sudo apt install python-pip

    wget https://repo.continuum.io/archive/Anaconda3-5.3.0-Linux-x86_$BITS.sh
    #sudo rm -rf anaconda3
    # the bash script provides -b for non-interactive - but with unwanted defaults
    echo -e "\n yes\n\nyes\n" | bash Anaconda3-5.3.0-Linux-x86_$BITS.sh
    rm Anaconda3-5.3.0-Linux-x86_$BITS.sh
fi

if [ "$INST_SQUIRREL" != "n" ]; then
	wget https://sourceforge.net/projects/squirrel-sql/files/1-stable/3.8.1/squirrel-sql-3.8.1-standard.jar/download
fi

# ----------------------------------------------------
# additional terminal tools
# ----------------------------------------------------
mkdir bin

echo "installing Fuzzy Finder"
wget https://github.com/junegunn/fzf/raw/master/install
mv install fzf-install.sh
chmod a+x fzf-install.sh
echo "yes\nyes\nyes\n\n" | ./fzf-install.sh

echo "installing micro editor"
MICRO_DIR=micro-1.4.1
wget https://github.com/zyedidia/micro/releases/tag/v1.4.1/$MICRO_DIR-linux$BITS.tar.gz
tar -xvf $MICRO_NAME-linux$BITS.tar.gz
cp $MICRO_DIR/micro bin/

# ----------------------------------------------------
# user/project dependent installations
# ----------------------------------------------------

if [ "$INST_RESILIO_SYNC" == "y" ]; then
    echo "install/run bittorrent-sync. use localhost:8888 to configure it"
    wget https://download-cdn.resilio.com/stable/linux-x$BITS/resilio-sync_x$BITS.tar.gz
    tar -xf resilio-sync_x$BITS.tar.gz
    ./rslsync
fi

if [ "$IP1" != "" ]; then
    echo "domain"
    wget http://download.beyondtrust.com/PBISO/8.0.0.2016/linux.deb.x$BITS/pbis-open-8.0.0.2016.linux.x86_$BITS.deb.sh
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
