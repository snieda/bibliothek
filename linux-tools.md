# Linux Tool Descriptions

## install terminal tools
	sudo apt-get -y install tmux mc tree broot archivemount ripgrep git nvim micro ne htop nmap nc tcpdump curl wget tinyproxy xclip poppler-utils dos2unix docx2txt catdoc fim cifs-utils openssh openvpn sshfs colordiff tar rar p7zip ntp xcompmgr w3m links2 inotify-tools fzf fzy mupdf abiword antiword

## bash

use file asteriks like **/myfile.*
	
	shopt -s globstar

add shortcuts for fast file find (like Ctrl+P) and command find (like Ctrl+Shift+P

	bind -x '"\C-r":"cat ~/.bash_history | fzy"'
	bind -x '"\C-g":"locate . | fzy"'
	bind -x '"\C-h":"apropos -s 1 \'' | fzy"'

## wget

	-m: mirror
	-p: page-requisites
	-k: convert to local
	--ignore-length
	-e robots=off --wait 1
	-E add file extensions
	--follow-ftp
	--reject file-rejlist
	-X --exclude dir-list
	-np --no-parent
	-N --timestamping only newer files
	--content-disposition tries to find extension through content
	wget -mpkE --follow-ftp --ignore-length -e robots=off --exclude forum

## tar

pack:
tar -czvf archive.tar.tgz /home/ubuntu --exclude=*.mp4

unpack:
tar -xvf archive.tar.tgz

## nmap

	nmap -p 8000-9000 -v  xxx.xxx.xxx.xxx

## curl --> jenkins REST-API

build mit parametern starten:

	curl -X POST https://jenkins.....de/job/projekt/view/gustav_flyway_environments/job/5_MYDB/build --user '<meinname>:<meinpasswort>' --insecure --data token=TOKEN --data-urlencode json='{"parameter": [{"name":"umgebung", "value":"MYNAME"}, {"name":"branch", "value":"<mydomain>"}]}'

letzten build auf result abfragen:

	curl --silent -X POST https://jenkins.....de/job/projekt/view/gustav_flyway_environments/job/5_MYDB/lastBuild/api/xml?xpath=/*/result --user '<myname>:<meinpasswort>' --insecure 

## rsync

syncronize source and remote destination directories:

	rsync -avzhu --progress /source /destination

## linux monitors

	netstat
	top
	htop
	lsof
	iftop

## hdd list

	lsblk

## freebsd

	camcontrol devlist #show all disks
	dmesg # show all system events

### create/format and mount a new partition with gpart

	gpart create -s GPT ada0 #create GPT partition on ada0
	gpart add -t freebsd-ufs ada0
	newfs -U /dev/ada0p1
	mkdir /media/newhdd
	echo "/dev/ada0p1      /media/newhdd      ufs     rw     2     2" >> /etc/fstab
	mount /media/newhdd

## hdd partitionieren und formatieren

	sudo mkdosfs -n 'Label' -I /dev/sdd -F 32

oder

	fdisk ...
	sudo mkfs.ext3 -n 'Label' -I /dev/sdd

## vmdk mounten

	sudo mount vmware-server-flat.vmdk /tmp/test/ -o ro,loop=/dev/loop1,offset=32768 -t ntfs

Mount a VMware virtual disk (.vmdk) file on a Linux box
Assumes XP/2000/2003. For Server 2008+ try offset=105,906,176 You can find this number in the System Information utility under Partition Starting Offset. UEFI based boxes you want partition 2 since the first is just the boot files (and FAT). This works with (storage side) snapshots which is handy for single file restores on NFS mounted VMware systems

## common internet file system mounten

	mount -t cifs //xxx.xxx.xxx.xxx/transfer /mnt -o user=ICH,domain=MEINEDOMAIN

oder 

	echo "connect network share drives"
	IP1 = //XX.XX.XX.XX
	USER1 = XX
	SHARE1 = Projekte
	sudo mkdir /media/$SHARE1
	sudo mount -t cifs -o username=$USER1 $IP1/$SHARE1 /media/$SHARE1/

## Platte partitionieren

	kpartx -av <image-flat.vmdk>; mount -o /dev/mapper/loop0p1 /mnt/vmdk

Mount a VMware virtual disk (.vmdk) file on a Linux box
This does not require you to know the partition offset, kpartx will find all partitions in the image and create loopback devices for them automatically. This works for all types of images (dd of hard drives, img, etc) not just vmkd. You can also activate LVM volumes in the image by running

	vgchange -a y

and then you can mount the LV inside the image.
To unmount the image, umount the partition/LV, deactivate the VG for the image

	vgchange -a n <volume_group>
then run
	
	kpartx -dv <image-flad.vmdk>
to remove the partition mappings.

## multi boot usb

http://multibootusb.org/page_guide/
https://www.ventoy.net/en/index.html

## find

	find -type f -mtime -365 -ls -regex "de[/]tsl2[/].*Definition.java"

### search for executable files that were accessed max 24 hours ago
	find -type f -executable -atime -1
### search files modified maximum 120 minutes ago
	find -type f -mmin -120
### search files created maximum 120 minutes ago without cache files
find -type f -regextype "sed" -regex ".*^(cache).*" -mmin -120

### convert files in a tree from iso8859-1 to utf-8
	find . -name "*.properties" -or -name "*.java" -type f -exec bash -c 'iconv {} -f ASCII//TRANSLIT -t UTF8 -o {}' \;

## ripgrep (rg)

### search in all directories and special files

	ripgrep-all or rga adapters: pandoc poppler-utils ffmpeg zip decompress sqlite
	example rga --rga-accurate mysearchstring

	docx2txt
	xlsx2txt
	lesspipe

## file renaming

	for f in abc*.txt do mv -- "$f" "${abc/nix}"; done

## cygwin
console package installer:

	wget https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
	chmod +x apt-cyg
	mv apt-cyg /usr/local/bin

## disk usage

	du -hc d 1 | sort -h

oder

	tree -d --du  -hc | grep "M]"

## xclip

	cat ~/.ssh/id_rsa.pub | xclip -sel clip

## progressbar

pv

	with process-substitution:
	cp <(pv $FILE_NAME) $NEW_FILE
	or
	pv MyDirectory/* | gzip > ./MyZip.gz

progress
	
	$! gets the last started background process:
	cp file newfile & progress -mp $!
	
bar

tqdm

	tar -v -xf tarfile.tar -C TARGET_DIR | tqdm --total $(tar -tvf tarfile.tar | wc -l) > /dev/null

## colored terminal output

	grc cat MYFILE
	
	bat MYFILE

	diff -yw --color=always <file1> <file2>

## maven

install a local jar file to your local maven repository:

	mvn install:install-file -Dfile=tsl2.nano.mavengenerator-2.3.1-20191208.174056-3.jar -DgroupId=net.sf.tsl2nano -DartifactId=tsl2.nano.mavengenerator -Dversion=2.3.1-SNAPSHOT -Dpackaging=de.tsl2.nano
	
or

	mvn -nsu install:install-file \
	   -Dfile=$1 \
	   -DgroupId=local.myorg \
	   -DartifactId=$ARTIFACTID \
	   -Dversion=1.0.0 \
	   -Dpackaging=jar \
	   -DgeneratePom=true


## git

Um den aktuellen Stand vom remote master in den eigenen branch zu mergen gibt es zwei Möglichkeiten:

	git pull origin master

oder

	git fetch origin
	git merge origin/master

Vergleich einer Datei in unterschiedlichen branches

	git diff <BRANCH-1> <BRANCH-2> <Dateipfad>

Anzeige der Historie mit Änderungs-Details

	git log --follow --grep=<pattern> --graph --cc <Dateipfad>

Was wurde bisher nur lokal committed (ohne durch push auf remote gespielt worden zu sein)

	git log <MY-BRANCH>...origin/<MY-BRANCH>

Vergleich mybranch --> master

	git diff mybranch...master
	
	ignoriere spaces und uebersichtlicher:
	
	git diff --color-words -w mybranch...master
	
	formatierte html-diff erstellen mit z.B. icdiff und ansi2html
		pip install git+https://github.com/jeffkaufman/icdiff.git
	in .gitconfig folgendes hinzufügen:
		[diff]
      		tool = icdiff
    		[difftool]
      		prompt = false
    		[difftool "icdiff"]
      		cmd = /usr/local/bin/icdiff --line-numbers $LOCAL $REMOTE
		
	git difftool develop..'develop@{2 weeks ago}' | ansi2html.sh > diff-develop-test.html
	
Vergleich letzter commit in HEAD
	
	git diff HEAD^ HEAD

or with two column side-by-side

	git difftool --word-diff=color -y -x "icdiff --line-numbers" HEAD^ HEAD | bat

Eigene Änderungen komplett überschreiben

	git clean -dfx
	git reset --hard HEAD

Auf einen früheren commit zurücksetzen

	git reset --hard <sha1-commit-id>
	
diff output als patch einfuegen

	# erzeuge patch fuer changes und new files
	git diff > meinbranchname.patch
	git diff --cached > meinbranchname-gitadded.patch
	
	# evtl. bisherige Aenderungen zuruecksetzen
	# git reset --hard
	# git clean -ndf
	git stash
	
	# patch einspielen
	git apply --3way --summary --check meinbranchname.patch
	git apply --3way meinbranchname.patch

bestimmte Dateien aus anderem branch übernehmen

	git checkout <BRANCH> -- <FILE-PATH>

Statistics

	git log --numstat | grep java > numstat.txt
	q -t "select sum(c1), sum(c2), c3 from numstat.txt group by c3 order by 1,2,3" > numstat-q.txt


Zurücksetzen auf master und holen von commits von remote oder anderem branch
	
	git reset --hard origin/master
	for commit in $(git log --reverse --since=yesterday --pretty=%H);
	do
    		git cherry-pick $commit
	done	

	ODER
	
	git rebase --onto branch~5 branch~3 branch
	# 5: start to remove, 3: start to rebase on further

### git cosmetics

	git commit --amend
	git rebase --interactive <-- squash, pick, edit, amend,...

### git auto merge conflicts
	git checkout --theirs PATH/FILE
	
	grep -l -R --include *.java '<<<<<<<' . | xargs git checkout --theirs
	or
	grep -lr '<<<<<<<' . | xargs git checkout --yours

### git revert merge request or commit

most git servers provide that per merge request or commit in the browser as option.
in the commandline you can revert with:

	git revert <commit-hash>

## TEXT

* vim (see: http://www.lucianofiandesio.com/vim-configuration-for-happy-java-coding)
	vjde (code completition)
	filled .vimrc
	exuberant-ctags (index for java-docs) 
	vim-plug: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	.vimrc  : https://gist.githubusercontent.com/facundovictor/42733b014bcc479f5cd8/raw/e53816453a21de40653906731ddb079d710b1531/.vimrc
	eclim   : wget https://github.com/ervandew/eclim/releases/download/2.8.0/eclim_2.8.0.bin
* ne:       nice editor http://ne.di.unimi.it/ (for cygwin/windows: http://ne.di.unimi.it/ne-cygwin-ansi-3.3.0-x86_64.tar.gz)
* slap:     https://github.com/slap-editor/slap
* micro:    https://github.com/zyedidia/micro/releases
* suplemon: https://github.com/richrd/suplemon

	icdiff
	ansi2html
	pdftotext

AsciiSignature: http://www.kammerl.de/ascii/AsciiSignature.php mit sub-zero

## FileManager

	mc    # midnightcommander
	lf    # configurable filemanager, written in go 
	broot # tree file manager with fast fuzzy search

## FILE CONCATENATE

	ls | xargs cat | tee output.txt

## TightVNC

	~/.vnc/xstartup:
	lxterminal & /usr/bin/lxsession -s Lubuntu &

	tightvncserver -geometry 1920x1080

## TMUX

* plugins: https://github.com/tmux-plugins
	* best of: TPM (tmux plugin manager), tmux resurrect

### TMUX + fzf

	tmux display-message -p -F "#{pane_current_path}" -t0
https://medium.com/njiuko/using-fzf-instead-of-dmenu-2780d184753f
	myVar=$(grep -Po "(?<=^HereIsAKey ).*" file)

## WINDOWS TOOLS

windows system tools http://www.nirsoft.net/x64_download_package.html
windows package manager: scoop (light, no admin required!)

##  Eclilpse Dark Theme

http://www.eclipsecolorthemes.org/?view=theme&id=55501

## Visual Studio Code Plugins

https://gist.github.com/snieda/0063c25f13cf8c9d5021941ca57ac895

## Hibernation

	pm-hibernate
	GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=<SWAP-UUID>"

	on problems (swap-partition must be active!):
	cat /etc/fstab
	sudo blkid
	cat /var/log/pm-suspend.log

	sudo update-initramfs -u

see https://www.reddit.com/r/Ubuntu/comments/61xfzk/hibernation_ubuntu_1604_unencrypted_swap/

## AntiVir / Trojan

sudo apt install clamav
sudo freshclam
sudo clamscan -r --bell -i /

sudo rkhunter --update
sudo rkhunter --propupd
sudo rkhunter --check

## stop a named process

	ps -uax | grep '[t]sl2' | tee | awk '{print $2}' | xargs kill
	
or simply:
	pkill  -f part-of-full-command
or find the pid:
	pgrep -f part-of-full-command	

## citrix problem with certificate: "Verbindung mit 0.0.0.2 Desktop kann nicht hergestellt werden"

	sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/
	sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/

## Windows in Linux: Wine in Docker with x11docker

https://hub.docker.com/r/x11docker/lxde

## VLC

tv m3u list

	https://github.com/jnk22/kodinerds-iptv

## linux desktop launcher

	kupfer

## system monitor in the desktop title

	indicator-multiload

## transparent linux windows

devilspie -a

### example script for devilspie in '~/.devilspie/chrome.ds

	( if
	( contains ( window_class ) "chrome" )
	( begin
	( spawn_async (str "xprop -id " (window_xid) " -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xcfffffff") )
	)
	)
	
### transparent linux windows from terminal

	sh -c 'xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * 80 / 100)))'

## gnome desktop extensions

	Extensions in : https://extensions.gnome.org/
	
	let you configure a system status bar (cpu, ram-use etc.)

## terminal image viewer
	feh or tiv

## best terminal browser
	elinks (but without javascript!, alternatives: links, links2, lynx, w3m, browsh)
	
## stop and continue processes to save battery power...
	SIGSTOP: kill -19 processId
	SIGCONT: kill -18 processId
	
	to see all possible signals: kill -l
	use pstree to see the main process Id: pstree -gp
	
## netcat alternative pwncat (python script)

	curl https://raw.githubusercontent.com/cytopia/pwncat/master/bin/pwncat

## Sql GraphViz

	https://github.com/rm-hull/sql_graphviz

## Send Keystroke to XWindows Application
	xdotool key --window "$(xdotool search --class Chromium | head -1)" Ctrl+Tab

## Check certificate path of a web-server through java keytool
	keytool -printcert -sslserver host:443

## HTTPS redirection on HTTP-Webapplication with certbot
	- creates/renews cert for application on port 80 
	https://certbot.eff.org/lets-encrypt/ubuntufocal-webproduct

## Application Network Traffic

nethogs -v 1
