# Linux Tool Descriptions

## wget

	-m: mirror
	-p: page-requisites
	-k: convert to local
	--ignore-length
	-e robots=off --wait 1
	--follow-ftp
	--reject file-rejlist
	-X --exclude dir-list
	-np --no-parent
	-N --timestamping only newer files
	--content-disposition tries to find extension through content
	wget -mpk --follow-ftp --ignore-length -e robots=off --exclude forum

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

## file renaming

	for f in abc*.txt do mv -- "$f" "${abc/nix}"; done

## install terminal tools
	sudo apt-get -y install mc tree ytree htop nmap git vim curl wget dos2unix conky mupdf abiword antiword xclip poppler-utils docx2txt catdoc fim vim cifs-utils openvpn colordiff w3m rar p7zip ntp ne xcompmgr tcpdump links2 tmux inotify-tools fzf

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
	
Eigene Änderungen komplett überschreiben

	git clean -dfx
	git reset --hard HEAD

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




## TEXT

vim (see: http://www.lucianofiandesio.com/vim-configuration-for-happy-java-coding)
	vjde (code completition)
	filled .vimrc
	exuberant-ctags (index for java-docs) 

slap:     https://github.com/slap-editor/slap
micro:    https://github.com/zyedidia/micro/releases
suplemon: https://github.com/richrd/suplemon

icdiff
ansi2html

AsciiSignature: http://www.kammerl.de/ascii/AsciiSignature.php mit sub-zero

## FILE CONCATENATE

	ls | xargs cat | tee output.txt

## TightVNC

~/.vnc/xstartup:
lxterminal & /usr/bin/lxsession -s Lubuntu &

tightvncserver -geometry 1920x1080

## TMUX + fzf

tmux display-message -p -F "#{pane_current_path}" -t0
https://medium.com/njiuko/using-fzf-instead-of-dmenu-2780d184753f
myVar=$(grep -Po "(?<=^HereIsAKey ).*" file)

## WINDOWS TOOLS

windows system tools http://www.nirsoft.net/x64_download_package.html
