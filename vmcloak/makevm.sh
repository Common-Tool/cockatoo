#!/bin/bash
set -xe

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]]; then
	echo "Usage: makevm.sh <name> <iso> <serial> <ip> <gateway>"
	exit
fi

# Directory where virtual machine will be stored, snapshots etc.
# This could be stored in tmpfs to gain additional speed
VMDIR=/mnt/vmcloak/vm

# Directory where hard disk images are stored
DATADIR=/mnt/vmcloak/data

ISODIR=/mnt/vmcloak/iso

NAME="$1"
ISO=$ISODIR/"$2"
SERIAL="$3"
IP="$4"
GW="$5"


ISO_MNT=`mktemp -d`

mount -o loop,ro $ISO $ISO_MNT
if [[ $? -ne 0 ]]; then
	echo "Unable to mount ISO!"
	exit
fi

vmcloak-init --winxp --iso-mount $ISO_MNT --serial-key $SERIAL $NAME

umount $ISO_MNT