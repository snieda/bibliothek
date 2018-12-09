# This script installs some commandline utils and the vim + python + java ide plugins
#
# Please download and install/extract http://repo.msys2.org/distrib/x86_64/msys2-x86_64-20180531.exe
# Then start msys2.exe and start this script!

APT=pacman -S --noconfirm
#APT=sudo apt -y install

echo "install system tools (~83MB)..."
$INST mc tree ytree htop git conky mupdf abiword antiword xclip fim cifs-utils  rar p7zip ntp xcompmgr tmux

echo "install console text tools..."
$INST vim ne dos2unix poppler-utils docx2txt catdoc colordiff icdiff colorized-logs kbtin pv bar ripgrep

echo "install networking tools..."
$INST nmap git curl wget openssh-server openvpn links2 w3m tightvncserver

echo "vim plugin dependencies"
$INST make cmake gcc silversearcher-ag exuberant-ctags
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl https://raw.githubusercontent.com/snieda/bibliothek/master/install-linux-dev-vm.sh
#wget https://github.com/ervandew/eclim/releases/download/2.8.0/eclim_2.8.0.bin
#chmod a+x eclim_2.8.0.bin

echo "python"
$INST python3 python3-pip flake8
pip install autopep8 pudb

echo "installing all plugins for our vim-ide"
vim +'PlugInstall --sync' +qa
