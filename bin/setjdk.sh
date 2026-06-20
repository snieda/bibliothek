#!/bin/bash
[ "$1" == "" ] && echo "Please give a path to java to be used and run this script with 'source'!" && ls -C -d /usr/lib/jvm/* ~/j* && read && exit 1
export JAVA_HOME=$1
export PATH="$JAVA_HOME/bin:$PATH"

echo "JAVA_HOME is now $JAVA_HOME"
echo "PATH is now $PATH"
java -version

[ "$2" != "" ] && shift && echo "starting $*" && sleep 1 && eval "$*" 
