#!/bin/sh
IP_ADDRESS=$(bx cs workers $(bx cs clusters | grep deployed | awk '{ print $1 }') | grep deployed | awk '{ print $2 }')
echo $IP_ADDRESS
sed -i '' 's/xx.xx.xx.xx/'$IP_ADDRESS'/g' ../manifests/deploy-nginx.yaml
