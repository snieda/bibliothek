# activate shell scripting
Set-ExecutionPolicy Unrestricted

# prepare base directory
$env:SCOOP='%USERPROFILE%\tools\scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

# install scoop
iwr -useb get.scoop.sh | iex
scoop update

# without 7zip and git we can't add buckets
scoop install 7zip git

# add package buckets
scoop bucket add extras 
scoop bucket add java 
scoop bucket add nonportable

# add tool for parallel downloading
scoop install aria2

# install cli tools
scoop install wget curl vim fzf broot mc lf busybox git psutils fd less bat 7zip googler ripgrep
scoop install make cmake grep sed coreutils diffutils

# install editors and additional working tools
scoop install links fman-np notepadplusplus freecommander graphviz cmder virtualbox-np
wget -nc https://sourceforge.net/projects/squirrel-sql/files/latest/download/squirrel-sql-client.jar
wget https://www.pendrivelinux.com/downloads/YUMI/YUMI-2.0.6.9.exe
wget https://www.pendrivelinux.com/downloads/YUMI/YUMI-UEFI-0.0.2.0.exe

# install linux console
scoop msys2

# install networking tools
scoop install openssh openvpn gnupg netcat nmap-portable putty kitty winscp tightvnc

# install languages
scoop openjdk python

# install language additions
scoop nodejs rust anaconda3 pip-tool
pip install -U pip
pip install flake8 autopep8 pudb


# install IDEs
scoop vscode-portable eclipse-jee
mkdir workspace
echo "https://gist.github.com/snieda/0063c25f13cf8c9d5021941ca57ac895" > workspace/settings-sync-gist.txt 
code --install-extension alphabotsec.vscode-eclipse-keybindings --install-extension  danields761.status-bar-breadcrumb --install-extension  dgileadi.java-decompiler --install-extension  donjayamanne.githistory --install-extension  donjayamanne.javadebugger --install-extension  DotJoshJohnson.xml --install-extension  eamodio.gitlens --install-extension  faustinoaq.javac-linter --install-extension  felipecaputo.git-project-manager --install-extension  IBM.XMLLanguageSupport --install-extension  masonicboom.web-browser --install-extension  ms-python.python --install-extension  ms-vsts.team --install-extension  msjsdiag.debugger-for-chrome --install-extension  qub.qub-xml-vscode --install-extension  redhat.java --install-extension  Shan.code-settings-sync --install-extension  VisualStudioExptTeam.vscodeintellicode --install-extension  vscjava.vscode-java-debug --install-extension  vscjava.vscode-java-dependency --install-extension  vscjava.vscode-java-pack --install-extension  vscjava.vscode-java-test --install-extension  vscjava.vscode-maven --install-extension  yzhang.markdown-all-in-one -a workspace

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.vimrc > .vimrc
vim +'PlugInstall --sync' +qa

# install standard gui applications
scoop install libreoffice-stable, vlc, googlechrome, firefox, opera, gimp
