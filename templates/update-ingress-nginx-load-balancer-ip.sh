#!/bin/bash

# exit on error
set -e

echo "=== $(date) ==="

namespace="{{ namespace | default('ingress-nginx') }}"
nginx_stream_conf_file="/etc/nginx/stream.conf.d/ingress_nginx_load_balancer.conf"
overwrite_flag=$(cat /tmp/overwrite-flag)

current_ip=$(kubectl --kubeconfig /opt/kubeconfig -n $namespace get service ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z $current_ip ]; then
  echo "invalid current_ip \"$current_ip\""
  echo "exit 1"
  exit 1
fi

previous_ip=$(cat $nginx_stream_conf_file | grep -oP '\d+\.\d+\.\d+\.\d+' | head -n 1)

if [ $overwrite_flag == "1" && $current_ip == $previous_ip ]; then
  echo "\"$current_ip\" == \"$previous_ip\" (no changes)"
  exit 0
fi

echo "\"$current_ip\" != \"$previous_ip\" (diff)"
echo "update nginx config"

config='# '$(date)'
# This file '$nginx_stream_conf_file' is generated and will be overwrited
server {
  listen 80;
  proxy_pass '$current_ip':80;
}
server {
  listen 443;
  proxy_pass '$current_ip':443;
}'

echo "$config" | tee $nginx_stream_conf_file
systemctl reload nginx