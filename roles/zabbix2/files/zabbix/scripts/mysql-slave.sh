#!/bin/bash
VAR=$1
RES=$(echo "show slave status\G"| mysql -uzabbix -pzbx@local |grep $VAR | cut -d: -f2 | sed 's/^ *//g')

if [ "$VAR" = "Slave_IO_Running" ]; then
	if [ "$RES" = "Yes" ]; then
		RES=1
	else
		RES=0
	fi
elif [ "$VAR" = "Slave_SQL_Running" ]; then
	if [ "$RES" = "Yes" ]; then
		RES=1
	else
		RES=0
	fi
fi
echo $RES
