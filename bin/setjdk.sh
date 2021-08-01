#!/bin/bash
[ "$1" == "" ] && echo "Please give a path to java to be used!" && exit 1
export JAVA_HOME=$1
export PATH="$JAVA_HOME/bin:$PATH"

echo "JAVA_HOME is now $JAVA_HOME"
echo "PATH is now $PATH"
java -version

[ "$2" != "" ] && echo "starting $1" && sleep 1 && shift && eval "$*" 
