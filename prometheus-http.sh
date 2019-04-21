#!/bin/sh

# Prometheus Pushgateway Job
job=guardian-network
# Prometheus Pushgateway IP:port
pushgateway_url=localhost:9091

# https_response {product_name} {monitor_site_name} {url} 
function https_response() {
	instance=${2}
	job_name=$job\_${1}
	#addr=`echo ${2}`
	# Get http information
	curl_info=`curl -X GET ${3} -w '%{response_code} %{time_appconnect}' -o /dev/null -s --insecure`
	response_code=`echo $curl_info|awk '{ print $1 }'`
	response_time=`echo $curl_info|awk '{print $2}'`
	# push value to prometheus_pushgateway
	echo 'http_response_code' $response_code | curl --data-binary @- http://$pushgateway_url/metrics/job/$job_name/instance/$instance
	echo 'http_response_time' $response_time | curl --data-binary @- http://$pushgateway_url/metrics/job/$job_name/instance/$instance
	## debug ##
	#echo $job_name
	#echo $instance
	#echo $response_code
	#echo $response_time
}



# google
https_response google google_gmail https://mail.google.com/mail/u/0/
https_response google google_maps https://www.google.com.tw/maps


