# prepare base directory
$env:SCOOP='%USERPROFILE%\tools\scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

# install scoop
iwr -useb get.scoop.sh | iex
scoop update

# add package buckets
scoop bucket add extras 
scoop bucket add java 
scoop bucket add nonportable

# add tool for parallel downloading
scoop install aria2

# install cli tools
scoop install fzf broot mc lf wget curl busybox git psutils

# install editors and additional working tools
scoop install fman-np vim graphviz cmder

# install networking tools
scoop install netcat nmap-portable putty kitty winscp

# install languages
scoop openjdk python

# install language additions
scoop nodejs rust anaconda3

# install IDEs
scoop vscode-portable eclipse-jee

# install standard gui applications
scoop install libreoffice-stable, vlc, googlechrome, opera, gimp
