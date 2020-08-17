#!/bin/sh

set -e
#set -x # for debuggging

echo "Starting d3servercheck"
if [ ! -f servers.csv ]; then
	echo "no servers.csv file found!"
	exit 1
fi

echo "Read servers"
echo "Starting checks"

subnet_regex='^37\.244\.3[23]'

while [ 1 ]; do
	sleep 5

	ips=$(netstat -n -t | awk '{ print $5; }' | grep $subnet_regex | cut -d : -f 1)
	if [ -z $ips ]; then
		echo 'no connection to Blizzard EU game servers detected'
		continue
	fi

	echo -n "connections: "
	for ip in $ips; do
		status=$(grep "^$ip" servers.csv || true)
		echo -n "$ip ("
		if [ -z $status ]; then
			echo 'unknown'
		else
			echo -n $status | cut -d , -f 2 | tr '[:lower:]' '[:upper:]'
		fi
		echo -n ") "
	done
	echo
done
