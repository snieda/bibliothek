#!/bin/bash
mkdir -p /tmp/"$1".archivemount; archivemount -o nonempty -o auto_unmount "$1" /tmp/"$1".archivemount; echo "/tmp/$1".archivemount
