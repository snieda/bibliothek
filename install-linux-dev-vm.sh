#!/bin/bash
##############################################################################
# install development-tools on linux (Thomas Schneider / 2016)
# 
# preconditions: debian 64bit system
# PLEASE SET: PRJ, IP1, USER1, SHARE1 before starting
##############################################################################

# ----------------------------------------------------
# system preparations
# ----------------------------------------------------
#echo "prepare (partionate, format) new disc /dev/sda"
#echo -e "o\nn\np\n\n\n\nw" | sudo fdisk /dev/sda
#sudo mkfs.ext4 -F -L "casper-rw" /dev/sda

echo "do some updates..."
sudo apt-get update
# sudo apt-get upgrade
echo "install system tools (~83MB)..."
sudo apt-get -y install mc tree ytree htop nmap git vim curl wget dos2unix conky mupdf abiword antiword xclip poppler-utils docx2txt catdoc fim vim cifs-utils openvpn colordiff links2 w3m rar p7zip ntp xcompmgr tmux ne openssh-server

echo "install virtualbox guest additions"
sudo apt-get -y install virtualbox-guest-utils virtualbox-guest-x11

echo "install java+netbeans..."
# wget http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk-nb/8u111-8.2/jdk-8u111-nb-8_2-linux-x64.sh
sudo bash jdk-8u111-nb-8_2-linux-x64.sh --silent &
wget http://plugins.netbeans.org/download/plugin/3380

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

echo "install python-anaconda..."
wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
#sudo rm -rf anaconda3
# the bash script provides -b for non-interactive - but with unwanted defaults
echo -e "\n yes\n\nyes\n" | bash Anaconda3-4.2.0-Linux-x86_64.sh

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
wget https://github.com/zyedidia/micro/releases/download/nightly/micro-1.1.5-dev.26-linux64.tar.gz
tar -xvf micro-1.1.5-dev.26-linux64.tar.gz
mv micro bin/

# ----------------------------------------------------
# user/project dependent installations
# ----------------------------------------------------

#echo "install/run bittorrent-sync. use localhost:8888 to configure it"
#wget https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz
#tar -xf resilio-sync_x64.tar.gz
#./rslsync

echo "connect network share drives"
IP1 = //XX.XX.XX.XX
USER1 = XX
SHARE1 = XXXX
sudo mkdir /media/$SHARE1
sudo mount -t cifs -o username=$USER1,gid=$USER,uid=$USER $IP1/$SHARE1 /media/$SHARE1/

echo "prepare ssh key to be copied to server machines"
echo -e "\n\n\n" | ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub | xclip -sel clip

echo "get git projects"
PRJ=XXX
git clone https://bitbucket.org/REPO/$PRJ.git workspace/$PRJ
pip install -r workspace/$PRJ/requirements.txt