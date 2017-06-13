#!/bin/bash
clear
read -d '' INTRO <<EOM
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

clear
echo $INTRO

# ----------------------------------------------------
# system preparations
# ----------------------------------------------------
DO_FORMAT=no
read -p  "Prepare (part, format) new disc /dev/sda (y|N): " DO_FORMAT
if [ "$DO_FORMAT" == "y" ]; then
    echo -e "o\nn\np\n\n\n\nw" | sudo fdisk /dev/sda
    sudo mkfs.ext4 -F -L "casper-rw" /dev/sda
    echo "Please restart the VM to include the formatted drive!"
    read -p "Restart now (Y|n) ? " RESTART_NOW
    if [ "$RESTART_NOW" == "" ] || [ "$RESTART_NOW" == "y" ]; then
	sudo halt --reboot
    fi
    exit
fi

echo "Installing development like Java+Netbeans, Python+Anaconda and Sublime-Text"

read -ep "Linux System Bit-width (32|64)                : " -i "64" BITS
read -ep "Virtualbox Version                            : " -i 5.1.6 VB_VERSION
read -p "Mount network-drive on IP                     : " IP1
if [ "$IP1" != "" ]; then
    read -p "Mount network-drive on PATH                   : " SHARE1
    read -p "Mount network-drive on USER                   : " USER1
    read -p "Clone GIT Repository                          : " REPO
    if [ "$REP0" != "" ]; then
        read -p "Git Project Name                             : " PRJ
    fi
fi

read -p "Install java8 + netbeans 8.2            (Y|n) : " INST_NETBEANS
read -p "Install python-anaconda 3.4             (Y|n) : " INST_ANACONDA
read -p "Install resilio sync                    (y|N) : " INST_RESILIO_SYNC

echo "do some updates..."
sudo apt-get update
# sudo apt-get upgrade
echo "install system tools (~83MB)..."
sudo apt-get -y install mc tree ytree htop git conky mupdf abiword antiword xclip fim cifs-utils  rar p7zip ntp xcompmgr tmux

echo "install console text tools..."
sudo apt-get -y install vim ne dos2unix poppler-utils docx2txt catdoc colordiff icdiff colorized-logs kbtin

echo "install networking tools..."
sudo apt-get -y install nmap git curl wget openssh-server openvpn links2 w3m tightvncserver

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

if [ "$INST_NETBEANS" != "n" ]; then
    echo "install java+netbeans..."
    # wget http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk-nb/8u111-8.2/jdk-8u111-nb-8_2-linux-x$BITS.sh
    sudo bash jdk-8u111-nb-8_2-linux-x$BITS.sh --silent &
    jdk-8u111-nb-8_2-linux-x$BITS.sh
    wget http://plugins.netbeans.org/download/plugin/3380
fi

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

if [ "$INST_ANACONDA" != "n" ]; then
    echo "install python-anaconda..."
    wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_$BITS.sh
    #sudo rm -rf anaconda3
    # the bash script provides -b for non-interactive - but with unwanted defaults
    echo -e "\n yes\n\nyes\n" | bash Anaconda3-4.2.0-Linux-x86_$BITS.sh
    rm Anaconda3-4.2.0-Linux-x86_$BITS.sh
fi

#sudo apt -y install python3 python3-pip python3-nose
sudo apt install python-pip

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
MICRO_DIR=micro-1.2.0
wget https://github.com/zyedidia/micro/releases/download/v1.2.0/$MICRO_DIR-linux$BITS.tar.gz
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
