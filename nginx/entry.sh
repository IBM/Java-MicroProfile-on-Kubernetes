#!/bin/bash
echo $SOURCE_IP
sed -i s/PLACEHOLDER_IP/$SOURCE_IP/g  /etc/nginx/nginx.conf
#exec /usr/bin/nginx -c /etc/nginx/nginx.conf
service nginx start
while true; do sleep 1d; done
