#!/bin/bash
read -d '' INTRO <<EOM
##############################################################################
# install development-tools on linux (Thomas Schneider / 2016)
# 
# preconditions: debian 64bit system
# PLEASE SET: PRJ, IP1, USER1, SHARE1 before starting
##############################################################################
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
read -p "Mount network-drive on IP                     : " IP1
if [ "$IP1" != "" ]; then
    read -p "Mount network-drive on PATH                   : " SHARE1
    read -p "Mount network-drive on USER                   : " USER1
    read -p "Clone Bitbucket Repository                    : " REPO
    if [ "$REP0" != "" ]; then
        read -p "Clone Bitbucket Project                       : " PRJ
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
sudo apt-get -y install nmap git curl wget openssh-server openvpn links2 w3m

echo "install virtualbox guest additions"
sudo apt-get -y install virtualbox-guest-utils virtualbox-guest-x11

if [ "$INST_NETBEANS" != "n" ]; then
    echo "install java+netbeans..."
    # wget http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk-nb/8u111-8.2/jdk-8u111-nb-8_2-linux-x64.sh
    sudo bash jdk-8u111-nb-8_2-linux-x64.sh --silent &
    wget http://plugins.netbeans.org/download/plugin/3380
fi

echo "install sublime-text + plugins..."
wget https://download.sublimetext.com/sublime-text_build-3126_amd64.deb
sudo dpkg-deb -x sublime-text_build-3126_amd64.deb /
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
    wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
    #sudo rm -rf anaconda3
    # the bash script provides -b for non-interactive - but with unwanted defaults
    echo -e "\n yes\n\nyes\n" | bash Anaconda3-4.2.0-Linux-x86_64.sh
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
./fzf-install.sh

echo "installing micro editor"
MICRO_DIR=micro-1.2.0
wget https://github.com/zyedidia/micro/releases/download/v1.2.0/$MICRO_DIR-linux64.tar.gz
tar -xvf $MICRO_NAME-linux64.tar.gz
cp $MICRO_DIR/micro bin/

# ----------------------------------------------------
# user/project dependent installations
# ----------------------------------------------------

if [ "$INST_RESILIO_SYNC" == "y" ]; then
    echo "install/run bittorrent-sync. use localhost:8888 to configure it"
    wget https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz
    tar -xf resilio-sync_x64.tar.gz
    ./rslsync
fi

if [ "$IP1" != "n" ]; then
    echo "domain"
    wget http://download.beyondtrust.com/PBISO/8.0.0.2016/linux.deb.x64/pbis-open-8.0.0.2016.linux.x86_64.deb.sh
    chmod +x pbis-open-8.0.0.2016.linux.x86_64.deb.sh
    sudo ./pbis-open-8.0.0.2016.linux.x86_64.deb.sh
    domainjoin-cli join $DOMAIN $DOMAIN_USER

    echo "connect network share drives"
    IP1 = ${IP1:-//XX.XX.XX.XX}
    USER1 = ${USER1:-XX}
    SHARE1 = ${SHARE1:-XXXX}

    sudo mkdir /media/$SHARE1
    sudo mount -t cifs -o username=$USER1,gid=$USER,uid=$USER $IP1/$SHARE1 /media/$SHARE1/
fi

echo "prepare ssh key to be copied to server machines"
echo -e "\n\n\n" | ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub | xclip -sel clip

if [ "$REPO" != "" ]; then
    echo "get git projects"
    REPO=${REPO:-XXXX}
    PRJ=${PRJ:-XXX}
    git clone https://bitbucket.org/$REPO/$PRJ.git workspace/$PRJ
    pip install -r workspace/$PRJ/requirements.txt
    cd workspace/$PRJ
    subl
fi
