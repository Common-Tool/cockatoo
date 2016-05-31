#!/bin/bash
set -em
# Initially background the API, then register with Distributed API
/usr/bin/python /cuckoo/utils/api.py -h 0.0.0.0 &
sleep 1
curl $CUCKOO_DIST_API/api/node -F name=$HOSTNAME -F url=http://`getent hosts $HOSTNAME | cut -f 1 -d ' '`:8090/
fg 1
curl -XDELETE $CUCKOO_DIST_API/api/node/$HOSTNAME