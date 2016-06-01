#!/bin/bash
for interface in eth0 p5p1 wlan0
do
	addr=`ip addr show $interface 2> /dev/null | grep 'inet ' | cut -f 6 -d ' ' | cut -f 1 -d '/'`
	if [[ ! -z "$addr" ]]; then
		echo $addr
		exit
	fi
done