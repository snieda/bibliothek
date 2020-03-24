REM install script to provide a development system on windows
REM Thomas Schneider 03/2020
REM https://sourceforge.net/projects/gnuwin32/files/wget/1.11.4-1/wget-1.11.4-1-bin.zip/download
REM https://chocolatey.org/install

# Set directory for installation - Chocolatey does not lock
# down the directory if not the default
$InstallDir='C:\Users\Public\chocoportable'
$env:ChocolateyInstall="$InstallDir"

# If your PowerShell Execution policy is restrictive, you may
# not be able to get around that. Try setting your session to
# Bypass.
Set-ExecutionPolicy Bypass -Scope Process -Force;

# All install options - offline, proxy, etc at
# https://chocolatey.org/install
# [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco upgrade chocolatey

# Tools
choco install -y -dir  wget curl netcat openssh openvpn nmap tightvnc
choco install -y -dir  fzf fd lf mc less bat 7zip vim googler ripgrep-all
choco install -y -dir  gnupg
choco install -y -dir  make
choco install -y -dir  cmake.portable
choco install -y -dir  msys2-installer
choco install -y -dir  freecommander-xe.install
curl https://dystroy.org/broot/download/x86_64-pc-windows-gnu/broot.exe -O ~/bin/broot
wget -nc https://sourceforge.net/projects/squirrel-sql/files/latest/download/squirrel-sql-client.jar

wget https://www.pendrivelinux.com/downloads/YUMI/YUMI-2.0.6.9.exe
wget https://www.pendrivelinux.com/downloads/YUMI/YUMI-UEFI-0.0.2.0.exe

# Antivir
choco install -y -dir  clamav

# Editors
#choco install -y -dir  visualstudiocode.portable -y # not yet available
choco install -y -dir  git.commandline -y
choco install -y -dir  notepadplusplus.commandline -y
choco install -y -dir  vim-tux.portable

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.vimrc > .vimrc
vim +'PlugInstall --sync' +qa

# Languages
choco install -y -dir  jdk8 maven
choco install -y -dir  jdk11
choco install -y -dir  anaconda3
choco install -y -dir  activeperl
choco install -y -dir  nodejs
choco install -y -dir  python pip

pip install -U pip
pip install flake8 autopep8 pudb

# IDEs
choco install -y -dir  eclipse-java-oxygen
choco install -y -dir  vscode
mkdir workspace
echo "https://gist.github.com/snieda/0063c25f13cf8c9d5021941ca57ac895" > workspace/settings-sync-gist.txt 
code --install-extension alphabotsec.vscode-eclipse-keybindings --install-extension  danields761.status-bar-breadcrumb --install-extension  dgileadi.java-decompiler --install-extension  donjayamanne.githistory --install-extension  donjayamanne.javadebugger --install-extension  DotJoshJohnson.xml --install-extension  eamodio.gitlens --install-extension  faustinoaq.javac-linter --install-extension  felipecaputo.git-project-manager --install-extension  IBM.XMLLanguageSupport --install-extension  masonicboom.web-browser --install-extension  ms-python.python --install-extension  ms-vsts.team --install-extension  msjsdiag.debugger-for-chrome --install-extension  qub.qub-xml-vscode --install-extension  redhat.java --install-extension  Shan.code-settings-sync --install-extension  VisualStudioExptTeam.vscodeintellicode --install-extension  vscjava.vscode-java-debug --install-extension  vscjava.vscode-java-dependency --install-extension  vscjava.vscode-java-pack --install-extension  vscjava.vscode-java-test --install-extension  vscjava.vscode-maven --install-extension  yzhang.markdown-all-in-one -a workspace

choco install -y -dir  kitty, winscp.portable
choco install -y -dir  winsshterm

# Standard Applications
choco install -y -dir  opera
choco install -y -dir  gimp
choco install -y -dir  vlc
choco install -y -dir  firefox
choco install -y -dir  googlechrome
choco install -y -dir  libreoffice-fresh
choco install -y -dir  virtualbox
choco install -y -dir  virtualbox-guest-additions-guest.install
choco install -y -dir  citrix-workspace
