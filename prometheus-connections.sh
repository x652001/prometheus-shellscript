#!/bin/sh

# Get connection status from local machine and push to prometheus_pushgateway

# Prometheus Pushgateway IP:port
pushgateway_ip='10.11.95.249:9091'

# Get connections
conn=`netstat -aunt | wc -l`
# Get TIME_WAIT
time_wait=`netstat -an|awk '/tcp/ {print $6}'|sort|uniq -c | grep TIME_WAIT | awk '{print $1}'`
# Get hostname
host=`hostname --short |sed 's/-/_/g'`

echo "connections $conn" | curl --data-binary @- http://$pushgateway_ip/metrics/job/pushgateway_monitor/instance/$host

if [ ! -n "$time_wait" ]
then
    echo "time_wait 0" | curl --data-binary @- http://$pushgateway_ip/metrics/job/pushgateway_monitor/instance/$host
else
    echo "time_wait $time_wait" | curl --data-binary @- http://$pushgateway_ip/metrics/job/pushgateway_monitor/instance/$host
fi

