#!/bin/bash
set -m
PIDFILE=/tmp/cuckoo-api.pid
if [[ -e $PIDFILE ]]; then
  PID=`cat /tmp/cuckoo-api.pid`
  if [[ -e /proc/$PID ]]; then
    kill -9 $PID
  fi
  rm -f $PIDFILE
fi
# Initially background the API, then register with Distributed API
/usr/bin/python /cuckoo/utils/api.py -H 0.0.0.0 &
echo $? > /tmp/cuckoo-api.pid
sleep 2
RES=`curl $CUCKOO_DIST_API/api/node -F name=$HOSTNAME -F url=http://$MYIP:8090/ | sed ':a;N;$!ba;s/\n/ /g'`
echo $RES | grep 'There is already a node' &> /dev/null
if [[ $? -eq 0 ]]; then
  RES=`curl $CUCKOO_DIST_API/api/node/$HOSTNAME -X PUT -F url=http://$MYIP:8090/ -F enabled=1 | sed ':a;N;$!ba;s/\n/ /g'`
fi
if [[ $? -ne 0 ]]; then
	echo "Failed to register node"
	kill %1
	exit 2
fi
fg 1
rm $PIDFILE
curl -XDELETE $CUCKOO_DIST_API/api/node/$HOSTNAME
