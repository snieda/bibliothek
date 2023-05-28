#!/bin/bash
clear
cat <<EOM
##############################################################################
# install development-tools on linux (Thomas Schneider / 2016-2022)
# 
# preconditions: linux (best: debian) or bsd system with package manager
# annotation   : on FreeBSD the bash is on: /usr/local/bin/bash
# tested on    : ubuntu, ghostbsd(freebsd), termux, msys2
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
echo "Thomas Schneider / 2016 (refreshed 2022-10)"
echo -------------------------------------------------------
echo

echo -------------------------------------------------------
echo "System : $(uname -a)"
echo "User   : $(id)"
echo -------------------------------------------------------
echo
ARCH=$(uname -m)
$Os=$(uname -s)
$os=${$(uname -s),,}

read -ep "Pckg Installer (apt,pacman,pkg,yum,yast,zypper): " -i "apt" PKG

if [ "$UID" == "0" ]; then # only on root priviledge
	$PKG install sudo > /dev/null #on minimized systems no sudo is available - you have to be root to install it!
fi
sudo -h > /dev/null #only to check, if available
if [ "$?" == "0" ]; then
	SUDO="sudo"
fi
echo

if [ "$PKG" == "apt" ];then #debian
	INST="$SUDO $PKG install -y --ignore-missing $*"
elif [ "$PKG" == "pacman" ];then #arch, msys2 (windows/cygwin)
	INST="$SUDO $PKG -S --noconfirm $*"
elif [ "$PKG" == "pkg" ];then #freebsd
	INST="$SUDO $PKG install -y --ignore-missing $*"
elif [ "$PKG" == "apk" ];then #alpine linux
	INST="$SUDO $PKG add $*"
elif [ "$PKG" == "yum" ];then #fedora
	INST="$SUDO $PKG install -y --skip-broken --tolerant $*"
elif [ "$PKG" == "yast" ];then #SUSE (old)
	INST="$SUDO $PKG --install $*"
elif [ "$PKG" == "zypper" ];then #openSUSE
	INST="$SUDO $PKG install --non-interactive --ignore-unknown --no-cd --auto-agree-with-licenses --allow-unsigned-rpm  $*"
fi

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
echo "============ System and VirtualBox informations ============"

read -p  "System upgrade                           (Y|n) : " INST_UPGRADE
read -ep "Linux System Bit-width (32|64)                 : " -i "64" BITS
read -p  "Termux Terminal Emulator System addons   (y|N) : " INST_TERMUX
read -p  "Unsecure (TimeServer:ntp, WinFS:samba)   (y|N) : " INST_UNSECURE
read -ep "Virtualbox Guest additions Version             : " -i 6.1.38 VB_VERSION
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
echo     "================== development IDE+Tools ===================="
read -p  "Install open jdk (openjdk-VERSION-jdk) Version : " -i 18 INST_JAVA
read -ep "Install graalvm java community         Version : " -i 22.2 INST_GRAALVM
read -ep "Install language server JDTLS          Version : " -i 1.16.0 INST_JDTLS
read -p  "Install nodejs                           (Y|n) : " INST_NODEJS
read -ep "Install python3.x+anaconda3            Version : " -i 2022.05 INST_PYTHON_ANACONDA
read -p  "Install resilio sync (data sync)         (y|N) : " INST_RESILIO_SYNC
read -p  "Console System only                      (Y|n) : " CONSOLE_ONLY
if [ "$CONSOLE_ONLY" == "n" ]; then
	echo     "===================== XWindows Desktops ====================="
	read -p  "Fluxbox (~5MB)                           (Y|n) : " INST_FLUX
	read -p  "LXDE Desktop (~250MB)                    (Y|n) : " INST_LXDE
	read -p  "Install wine (~400MB)                    (Y|n) : " INST_WINE
	echo    "================ Standard Desktop Applications ==============="
	read -p  "Install firefox                         (Y|n)  : " INST_FIREFOX
	read -p  "Install libreoffice                     (Y|n)  : " INST_LIBREOFFICE
	read -p  "Install vlc                             (Y|n)  : " INST_VLC
	read -p  "Install citrix-workspace-app            (Y|n)  : " INST_CITRIX
	read -p  "Install virtual box                     (Y|n)  : " INST_VIRTUALBOX
	read -p  "Install gparted                         (Y|n)  : " INST_GPARTED
fi
if [ "$CONSOLE_ONLY" == "n" ]; then
	echo    "======================= Desktop IDEs ========================"
	read -p  "Install visual studio code (~40MB)       (Y|n) : " INST_VSCODE
	read -ep "Install eclipse (~300MB)                 (Y|n) : " -i 2022-09 INST_ECLIPSE
	read -ep "Install netbeans                       Version : " -i 13 INST_NETBEANS
	read -p  "Install theia                            (y|N) : " INST_THEIA
	read -p  "Install fman (Ctrl+p filemanager)        (Y|n) : " INST_FMAN
	read -p  "Install sublimetext+python-plugins       (Y|n) : " INST_SUBLIMETEXT
	read -p  "Install squirrel (sql)                   (Y|n) : " INST_SQUIRREL
fi

read -p ">>>>>> !!! START INSTALLATION ? <<<<<<  (Y|n)  : " START
if [ "$START" == "n" ]; then
	exit
fi
echo "do some updates..."
$SUDO $PKG update
if [ "$INST_UPGRADE" != "n" ]; then
	$SUDO $PKG -y upgrade
fi

echo "provide initial .profile"
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.profile >> .profile

echo "install system tools (~83MB)..."
for i in mc tree ytree htop git mupdf antiword fim decompress zip rar p7zip tmux exfat-fuse sqlite; do $INST $i; done

echo "install console text tools..."
for i in vim ne dos2unix poppler-utils docx2txt xlsx2txt lesspipe ffmpeg pandoc catdoc kbtin pv bar rg ripgrep rga ripgrep-all expect; do $INST $i; done

echo "install console text color tools"
for i in colordiff icdiff colorized-logs grc bat; do $INST $i; done

echo "install networking tools..."
for i in nmap git curl wget openssh openssh-server openvpn gnupg lynx links2 w3m w3m-img tightvncserver tinyproxy nethogs; do $INST $i; done

echo "install printer drivers..."
$INST printer-driver-cups-pdf

if [ "$CONSOLE_ONLY" == "n" ]; then
	if [ "$INST_TERMUX" == "y" ]; then
		$INST x11-repo xorg-xclock tigervnc # only for termux
		mkdir ~/ubuntu_directory
		cd ~/ubuntu_directory
		wget https://raw.githubusercontent.com/Neo-Oli/termux-ubuntu/master/ubuntu.sh
		bash ubuntu.sh
		touch ~/.hushlogin
		cd
	fi
	echo "echo install xwin-system tools"
	for i in xclip xclock xcompmgr devilspie conky kupfer abiword pm-utils; do $INST $i; done
fi

echo "tool configurations (mc, tmux, etc...)"
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.tmux.conf > .tmux.conf
mkdir -p bin
mkdir -p .config/mc
mkdir -p .termux
mkdir -p shell
mkdir -p .config/lf
mkdir -p .config/broot
mkdir -p .config/micro

curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/mc/ini > .config/mc/ini
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/mc/panels.ini > .config/mc/panels.ini
curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash > shell/key-bindings.bash
curl https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash > shell/completion.bash
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.termux/termux.properties > .termux/termux.properties
curl https://raw.githubusercontent.com/snieda/bibliothek/master/etc/lf/lfrc > .config/lf/lfrc
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/broot/conf.toml > .config/broot/conf.toml
echo "alias ll='ls -alF'" >> .profile

# ----------------------------------------------------
# additional terminal tools
# ----------------------------------------------------

curl https://www.gnu.org/software/bash/manual/bash.txt > bash.txt

mkdir -p .local/share/fonts

echo "python3"
for i in python python-pip python3 python3-pip flake8 autopep8 pudb; do $INST $i; done
for i in python-flake8 python-autopep8 python-pudb; do $INST $i; done #second try...
pip install -U pip
pip install flake8 autopep8 pudb # on some distributions, it may be available on pip

if [ "$PKG" == "pkg" ]; then # mostly freenbsd
	for i in py37-pip; do $INST $i; done
fi

echo "installing developer font 'fantasque sans mono' to be used by terminal or vim/devicons"
curl -L https://github.com/belluzj/fantasque-sans/releases/download/v1.8.0/FantasqueSansMono-Normal.tar.gz | tar xzC ~/.local/share/fonts

cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
cd ~

echo "nnn filemanager with icons"
curl https://github.com/jarun/nnn/releases/download/v4.2/nnn-nerd-static-4.2.x86_64.tar.gz  | tar xzC ~/bin
curl https://github.com/Canop/broot/raw/master/resources/icons/vscode/vscode.ttf > ~/.local/share/fonts/vscode.ttf

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
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/micro/settings.json > .config/micro/settings.json
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.config/micro/bindings.json > .config/micro/bindings.json
micro -plugin install aspell editorconfig filemanager fish fzf jump lsp  quickfix wc autoclose comment diff ftoptions linter literate status

echo "lf filemanager and additional cli tools"
for i in lf nnn progress autojump archivemount sshfs fzy locate apropos; do $INST $i; done
curl -L https://github.com/gokcehan/lf/releases/download/r13/lf-linux-amd64.tar.gz | tar xzC ~/bin

echo "plugins for nnn filemanager"
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

echo "installing googler"
curl https://raw.githubusercontent.com/jarun/googler/v4.2/googler -o ~/bin/googler && chmod a+x ~/bin/goolger

echo "installing broot tree+fzf like file browser"
curl https://dystroy.org/broot/download/$ARCH-$os/broot -o ~/bin/broot && chmod a+x ~/bin/broot

if [ "$INST_UNSECURE" == "y" ]; then
	echo "Hetzner NTP WARNING: enables DDOS attacks!"
	$INST ntp
	echo "CIFS contains main server of SAMBA-4: smbd, nmbd (network access on windows filesystem and printers)"
	$INST cifs-utils
fi

if [ "$INST_ANTIVIR" != "n" ]; then
	echo "install antiviren (clam-av, rk-hunter..."
	$INST clamav rkhunter
fi

echo "vim plugin dependencies"
for i in vim-python python-dev python3-dev make cmake gcc silversearcher-ag exuberant-ctags build-essential; do $INST $i; done
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl https://raw.githubusercontent.com/snieda/bibliothek/master/.vimrc > .vimrc
#wget https://github.com/ervandew/eclim/releases/download/2.8.0/eclim_2.8.0.bin
#chmod a+x eclim_2.8.0.bin

if [ "$INST_JAVA" != "" ]; then
    echo "install java openjdk-$INST_JAVA-jdk..."
    #wget -nc http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
    #wget -nc --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn/java/jdk/8u211-b12/478a62b7d4e34b78b671c754eaaf38ab/jdk-8u211-linux-x$BIT.tar.gz
    #wget  --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/15+36/779bf45e88a44cbd9ea6621d33e33db1/jdk-15_windows-x64_bin.zip
	#sudo tar xfz jdk-8u191-linux-x$BITS.tar.gz
	#sudo ln -s java jdk1.8.0_191
	#ls -l /usr/local/sbin/
	
	[ "$(pwd)" == *"com.termux"* ] && TERMUX=/data/data/com.termux/files # more generic: TERMUX=${$(pwd)%/home}
	echo "export JAVA_HOME=$TERMUX/usr/lib/jvm/java-8-openjdk-amd64" >> .profile
	#echo "export JAVA_HOME=/usr" >> .profile
	echo "PATH=$JAVA_HOME/bin:$PATH" >> .profile
	
	for i in openjdk-$INST_JAVA-jdk maven; do $INST $i; done
	
	echo "call 'sudo update-alternatives --config java' to select/config the desired java"

	MVN=apache-maven-3.8.6
	wget http://www.apache.org/dist/maven/maven-3/3.8.6/binaries/$MVN-bin.tar.gz
	tar -xf $MVN-bin.tar.gz
	echo "export M2_HOME=$(pwd)/$MVN" >> .profile
	echo "export MAVEN_HOME=$(pwd)/$MVN" >> .profile
	echo "export PATH=$M2_HOME/bin:$PATH" >> .profile

	curl https://www.benf.org/other/cfr/cfr-0.152.jar > bin/cfr-0.152.jar
fi

if [ "$INST_GRAALVM" != "" ]; then
	GRAAL=graalvm-ce-java-linux-amd$BIT-$INST_GRAALVM
	wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$INST_GRAALVM/$GRAAL.tar.gz
	tar -xf $GRAAL.tar.gz
	echo "export JAVA_HOME=$(pwd)/$GRAAL" >> .profile
	echo "PATH=$JAVA_HOME/bin:$PATH" >> .profile
	
	if [ "$MVN" == "" ]; then
		MVN=apache-maven-3.6.3
		wget http://www.apache.org/dist/maven/maven-3/3.6.3/binaries/$MVN-bin.tar.gz
		tar -xf $MVN-bin.tar.gz
		echo "export M2_HOME=$(pwd)/$MVN" >> .profile
		echo "export MAVEN_HOME=$(pwd)/$MVN" >> .profile
		echo "export PATH=$M2_HOME/bin:$PATH" >> .profile
	fi
fi

if [ "$INST_JDTLS" != "" ]; then
	JDTLS=jdt-language-server-$INST_JDTLS
	if [ ! -f "$JDTLS" ]; then
		rm jdtls-latest.txt
		wget -nc https://download.eclipse.org/jdtls/milestones/$INST_JDTLS/latest.txt -O jdtls-latest.txt
		wget -nc https://download.eclipse.org/jdtls/milestones/$INST_JDTLS/$(<jdtls-latest.txt) -O $JDTLS.tar.gz
		tar -xf $JDTLS.tar.gz
		echo "export PATH=$JDTLS/bin:$PATH" >> .profile
	fi
fi

echo "installing all plugins for our vim-ide"
vim +'PlugInstall --sync' +qa

if [ "$INST_PYTHON_ANACONDA" != "" ]; then
    echo "install python+anaconda..."
	$INST python3 python3-pip python3-nose
	$INST python-pip
    ANACONDA_FILE=Anaconda3-$INST_PYTHON_ANACONDA-$Os-$ARCH.sh
    if [ ! -f "$ANACONDA_FILE" ]; then
    	wget -nc https://repo.continuum.io/archive/$ANACONDA_FILE
    fi
    #sudo rm -rf anaconda3
    # the bash script provides -b for non-interactive - but with unwanted defaults
    echo -e "\nyes\n\nyes\nyes\n" | $ANACONDA_FILE
    # rm $ANACONDA_FILE
    # upgrade all python modules
    pip list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U
fi

if [ "$INST_NODEJS" != "n" ]; then
	$INST nodejs
fi

if [ "$CONSOLE_ONLY" == "n" ]; then

	if [ "$INST_LXDE" != "n" ]; then
		echo "install lxde..."
		$INST lxde lxde-core
	fi

	if [ "$INST_FLUX" != "n" ]; then
		echo "install flux..."
		$INST fluxbox
		mkdir -p .vnc
		curl https://raw.githubusercontent.com/snieda/bibliothek/master/.vnc/xstartup > .vnc/xstartup
		chmod a+x .vnc/xstartup
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

	if [ "$INST_FMAN" != "n" ]; then
		echo "install fman..."
		#curl https://fman.io/download/thank-you?os=$Os&distribution=Ubuntu
		$SUDO apt-key adv --keyserver keyserver.ubuntu.com --recv 9CFAF7EB
		$INST apt-transport-https
		echo "deb [arch=amd64] https://fman.io/updates/ubuntu/ stable main" | $SUDO tee /etc/apt/sources.list.d/fman.list
		$INST fman
	fi

	if [ "$VB_VERSION" != "" ]; then
		echo "install virtualbox guest additions"
		#$INST virtualbox-guest-utils virtualbox-guest-x11
		$INST $os-headers-$(uname -r) build-essential dkms
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
	#	wget -nc https://www.libreoffice.org/donate/dl/deb-$ARCH/6.1.2/de/LibreOffice_6.1.2_$Os_$ARCH_deb.tar.gz
	#	tar -xvf LibreOffice_6.1.2_$Os_$ARCH_deb.tar.gz
	#	cd debs
	#	sudo dpkg -i *.deb
	#	sudo apt-get -f install
	#	cd ..
		$INST libreoffice-common
	fi

	if [ "$INST_CITRIX" != "n" ]; then
	    echo "install citrix workspace app..."
	    wget  -nc --no-check-certificate --no-cookies https://downloads.citrix.com/15918/linuxx64-19.3.0.5.tar.gz?__gda__=1560365066_f53cf2cdbacbfbb07d9baecb77691004
	    $SUDO dpkg -i *.deb
	    $SUDO apt-get -f install
	fi


	if [ "$INST_VLC" != "n" ]; then
		echo "install vlc..."
		$INST vlc-nox vlc
	fi


	if [ "$INST_SQUIRREL" != "n" ]; then
		SQUIRREL_FILE=squirrel-sql-client.jar
		if [ ! -f "$SQUIRREL_FILE" ]; then
			wget -nc https://sourceforge.net/projects/squirrel-sql/files/latest/download -O $SQUIRREL_FILE
		fi
	fi

	if [ "$INST_NETBEANS" != "" ]; then
	    echo "install netbeans..."
	    # wget -nc http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-$os-i586.tar.gz
	    NETBEANSFILE=Apache-NetBeans-$INST_NETBEANS-bin-$os-x$BITS.sh
	    if [ ! -f "$NETBEANSFILE" ];then
		#wget -nc --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk-nb/8u111-8.2/$NETBEANSFILE
		wget -nc --no-check-certificate --no-cookies https://www.apache.org/dyn/closer.cgi/netbeans/netbeans-installers/$INST_NETBEANS/$NETBEANSFILE
		#wget http://plugins.netbeans.org/download/plugin/3380
	    fi
	    $SUDO bash $NETBEANSFILE --silent &
	    source $NETBEANSFILE
	fi

	if [ "$INST_THEIA" != "n" ]; then
	    echo "install theia..."
	    THEIAFILE=TheiaBlueprint.AppImage
	    if [ ! -f "$THEIAFILE" ];then
		wget -nc --no-check-certificate --no-cookies https://www.eclipse.org/downloads/download.php?file=/theia/latest/$os/TheiaBlueprint.AppImage&r=1
	    fi
	    $SUDO bash $THEIAFILE --silent &
	    source $THEIAFILE
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

	if [ "$INST_ECLIPSE" != "" ]; then
	    echo "install eclipse..."
		ECLIPSE_FILE=eclipse-jee-$INST_ECLIPSE-R-$os-gtk-$ARCH.tar.gz
		if [ ! -f "$ECLIPSE_FILE" ]; then
			wget -nc http://ftp.fau.de/eclipse/technology/epp/downloads/release/$INST_ECLIPSE/R/$ECLIPSE_FILE
		fi
		$SUDO tar xfz $ECLIPSE_FILE
		$SUDO ln -s /eclipse/eclipse /usr/local/sbin/eclipse
		ls -l /usr/local/sbin/
	fi

	if [ "$INST_SUBLIMETEXT" != "n" ]; then
		echo "install sublime-text + plugins..."
		SUBL_FILE=sublime-text_build-3126_amd$BITS.deb
		if [ ! -f "$SUBL_FILE" ]; then
			wget -nc https://download.sublimetext.com/$SUBL_FILE
		fi
		$SUDO dpkg-deb -x $SUBL_FILE /
		if [ $? != 0 ]; then
			$SUDO dpkg -i $SUBL_FILE
		fi
		#rm $SUBL_FILE
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
fi

# ----------------------------------------------------
# user/project dependent installations
# ----------------------------------------------------

if [ "$INST_RESILIO_SYNC" == "y" ]; then
    echo "install/run bittorrent-sync. use localhost:8888 to configure it"
    wget -nc https://download-cdn.resilio.com/stable/$os-x$BITS/resilio-sync_x$BITS.tar.gz
    tar -xf resilio-sync_x$BITS.tar.gz
    ./rslsync
fi

if [ "$DOMAIN" != "" ]; then
    echo "domain"
    wget -nc http://download.beyondtrust.com/PBISO/8.0.0.2016/$os.deb.x$BITS/pbis-open-8.0.0.2016.$os.$ARCH.deb.sh
    chmod +x pbis-open-8.0.0.2016.$os.$ARCH.deb.sh
    sudo ./pbis-open-8.0.0.2016.$os.$ARCH.deb.sh
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
	echo 'export DISPLAY=0:0' >> .profile
else
	echo "not setting DISPLAY in console mode"
fi
# reload profile
cd
source .profile

echo -------------------------------------------------------
echo "Installation finished successfull"
echo "Please have a look into your .profile"
echo "Use 'br' as filemanager and micro, ne or vim as editor"
echo -------------------------------------------------------
