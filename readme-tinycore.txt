Tastatur und Home beim Start in der Virtualbox:
TAB: tce=sda opt=sda home=sda kmap=qwertz/de

kmap
mc
virtualbox-additions

usb.vmdk für USB-Bootstick in der Virtualbox erstellen:
------------------------------------------------------------------------
VBoxManage internalcommands createrawvmdk -filename C:\usb.vmdk -rawdisk \\.\PhysicalDrive#

------------------------------------------------------------------------
sudo mount vmware-server-flat.vmdk /tmp/test/ -o ro,loop=/dev/loop1,offset=32768 -t ntfs

Mount a VMware virtual disk (.vmdk) file on a Linux box
Assumes XP/2000/2003. For Server 2008+ try offset=105,906,176 You can find this number in the System Information utility under Partition Starting Offset. UEFI based boxes you want partition 2 since the first is just the boot files (and FAT). This works with (storage side) snapshots which is handy for single file restores on NFS mounted VMware systems

------------------------------------------------------------------------
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

------------------------------------------------------------------------
MC (Midnight Commander) fans can add following binding in ~/.mc/bindings and view the text content of .docx file by hitting F3 function key after selecting the concerned docx document.
# Microsoft .docx Document
regex/\.(docx|DOCX|Docx)$
	View=%view{ascii} docx2txt.pl %f -
------------------------------------------------------------------------
Linux-Tools:
java, javac, ant, wget, mc, (ytree?, emacs?), nc/netcat/nmap, netstat, tmux, tmux-resurrect, git, svn, vim, curl, dos2unix, (gui: emel-fm2, dillo, firefox, torsmo/conky, mupdf, abiword), pdf2text, antiword, doc2txt (regex for mc), pandoc (markdown), htop, tree, xclip poppler-utils(pdftotext, less *.pdf) docx2txt, catdoc (office to plain text) caca-utils, fim (image-viewer in terminal) terminology (graphical terminal) vim-plug (nerdtree, supertab, syntastic, undotree, TagBar, vim-vebugger) cifs-utils (mount network (windows) drives) resilio-sync (localhost:888)

Tools on TinyCore:
-- FILE
mc, rsync, xfe(xwindows), vim
-- DOC
abiword
-- SERVER
openssh, openvpn, bftpd, busybox-httpd
-- DEVELOP
git, svn, oracle java, netbeans, sublime-text (plugins: git, grep, sidebar-extensions, sidebar-sync)
--BROWSER
firefox, opera, lynx, elink

install development-linux
------------------------------------------------------------------------
sudo apt-get update
sudo apt-get upgrade
83MB --> sudo apt-get -y install mc, tree, ytree, htop, nmap, git, svn, vim, curl, wget, dos2unix, dillo, conky, mupdf, abiword, antiword, doc2txt, xclip, poppler-utils, docx2txt, catdoc, fim, vim, cifs-utils openssh openvpn bftpd busybox-httpd
# wget http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-i586.tar.gz
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk-nb/8u111-8.2/jdk-8u111-nb-8_2-linux-i586.sh

wget https://download.sublimetext.com/sublime-text_build-3126_i386.deb
sudo dpkg-deb -x sublime-text_build-3126_i386.deb .
wget  https://packagecontrol.io/Package%20Control.sublime-package
cp Package%20Control.sublime-package ~/.config/sublime-text-3/Installed Packages
vim ~/.config/sublime-text-3/Packages/User/Package Control.sublime-settings
{
    "installed_packages":
    [
        "AutoFileName",
        "BracketHighlighter",
        "ExportHtml",
        "GenerateUUID",
        "HexViewer",
        "Neon Color Scheme",
        "PackageResourceViewer",
        "PlistJsonConverter",
        "Python Flake8 Lint",
        "Python Improved",
        "SideBarEnhancements",
        "SideBarGit",
        "SublimeCodeIntel",
        "SublimeREPL",
        "Tag",
        "Terminal",
        "Theme - Soda"
    ]
}
   "installed_packages":
    [
        "Anaconda",
        "AutoFileName",
        "Block Cursor Everywhere",
        "BracketHighlighter",
        "CursorRuler",
		"Diff",
		"FuzzyFileName",
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
		"SublimeEnhancements",
        "SublimeREPL",
        "SyncedSideBar"
        "Terminal",
    ]
}
wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86.sh

sudo bash jdk-8u111-nb-8_2-linux-i586.sh --silent
sudo bash Anaconda3-4.2.0-Linux-x86.sh -b

sublime-text package installer
------------------------------------------------------------------------
import urllib.request,os,hashlib; h = 'df21e130d211cfc94d9b0905775a7c0f' + '1e3d39e33b79698005270310898eea76'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
------------------------------------------------------------------------
