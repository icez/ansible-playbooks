#!/bin/bash

MAILLOG=/usr/local/psa/var/log/maillog
DAT1=/tmp/zabbix-postfix-offset.dat
DAT2=$(mktemp)
PFLOGSUMM=/usr/sbin/pflogsumm
ZABBIX_CONF=/etc/zabbix/zabbix_agentd.conf
DEBUG=1

function zsend {
  key="postfix[`echo "$1" | tr ' -' '_' | tr '[A-Z]' '[a-z]' | tr -cd [a-z_]`]"
  value=`grep -m 1 "$1" $DAT2 | awk '{print $1}'`
  value=`echo $value | sed s/k/000/g`
  [ ${DEBUG} -ne 0 ] && echo "Send key \"${key}\" with value \"${value}\"" >&2
  /usr/bin/zabbix_sender -c $ZABBIX_CONF -k "${key}" -o "${value}" 2>&1 >/dev/null
}

/usr/sbin/logtail -f$MAILLOG -o$DAT1 | $PFLOGSUMM -h 0 -u 0 --no_bounce_detail --no_deferral_detail --no_reject_detail --no_no_msg_size --no_smtpd_warnings > $DAT2

zsend received
zsend delivered
zsend forwarded
zsend deferred
zsend bounced
zsend rejected
zsend held
zsend discarded
zsend "reject warnings"
zsend "bytes received"
zsend "bytes delivered"
zsend senders
zsend recipients

rm $DAT2

