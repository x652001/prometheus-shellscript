#!/bin/bash

# This script for getting docker container connection and push to prometheus pushgateway 

# Prometheus Pushgateway IP:port
pushgateway_ip='10.11.95.249:9091'

# Get Cypress Container ID
containerID=$(docker ps | grep /order: | cut -d ' ' -f 1)

# Get Cypress Order connection to Mongo
mongo93_conn=`docker exec $containerID netstat -na  | awk '{print $5,$6}'| sort | uniq -c | sort -n | grep 192.168.10.93:27017 | grep ESTABLISHED | awk '{print $1}'`

# Get hostname
host=`hostname --short`

# Push mongo_conn to pushgateway
if [ ! -n "$mongo93_conn" ]
then
    echo "mongo93_conn 0" | curl --data-binary @- http://$pushgateway_ip/metrics/job/pushgateway_monitor/instance/$host
else
    echo "mongo93_conn $mongo93_conn" | curl --data-binary @- http://$pushgateway_ip/metrics/job/pushgateway_monitor/instance/$host
fi
