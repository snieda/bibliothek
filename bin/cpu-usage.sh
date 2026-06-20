#!/bin/bash
# print cpu usage of given processname
# usage cpu-usage <processname>
[[ "$1" == "" ]] && head -n 3 && exit 1

watch -n 2 "printf "$1: "; ps -eo pcpu,command --sort -pcpu | grep $1 | awk '{p=\$1 ; sum +=p} END {print sum}'"