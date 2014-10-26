#!/bin/bash
DISKS=$(cat /proc/partitions | grep -v '#blocks'|grep -vE "^$" |awk ' { print $4 } ')
FIRST="yes"
echo "{";
echo "	\"data\":["

for i in $DISKS ; do
	if [ "$FIRST" = "no" ]; then
		echo ","
	fi
	echo -n "	{\"{#DEVNAME}\":\"$i\"}"
	FIRST="no"
done
echo 
echo "	]"
echo "}"
