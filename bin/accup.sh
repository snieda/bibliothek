#!/bin/bash
# stop some service to optimize system running time on accu (Thomas Schneider /2025)
# to optimize cpu start: powertop --auto-tune
# to stop, kill or start explicite applications, give parameters "[start|stop(default:kill)] appication name"
#
# usage accup.sh [ [start|stop] <application-name>] | ['s' + <systemctl-action like start or stop> [service-name] ] 

uname -a

if [[ "$1" == "st"* ]]; then
	[[ "$1" == "start" ]] && action="-18"
	[[ "$1" == "stop" ]] && action="-19"
	echo "=> pkill $action --full $2..."
	pkill -e $action --full "$2"
else
	action=stop
	[[ "$1" != "" ]] && action=$( echo "$1" | cut -c 2-99)
	if [[ "$2" != "" ]]; then
		echo "running systemctl $action $2"
		sudo systemctl $action "$2"
	else
		echo "running sytemctl on all with: $action"
		sudo gitlab-runner stop
		sudo systemctl $action gitlab-runner
		sudo systemctl $action snapd.socket
		sudo systemctl $action snapd.service
		sudo systemctl $action docker.socket
		sudo systemctl $action docker.service
		sudo systemctl $action podman.socket
		sudo systemctl $action podman.service
		sudo systemctl $action postgresql
		sudo systemd-analyze time
		sudo systemd-analyze blame | head
	fi
fi

# workaround since 04/2026
export DOCKER_API_VERSION=1.44