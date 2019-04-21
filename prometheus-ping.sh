#!/bin/bash

job=guardian-ping
pushgateway_url=localhost:9091

function pingtime() {
	instance=${1}
	addr=`echo ${2}|sed 's/\./\_/g'`
	pt=`ping -c 1 ${2} | awk '{ print $8 }'|sed 2q|sed -n '$p'|sed 's/[a-zA-Z=]//g'`
	echo 'ping_'$addr $pt | curl --data-binary @- http://$pushgateway_url/metrics/job/$job/instance/$instance
}




pingtime google www.google.com
