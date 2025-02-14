#!/bin/bash

# exit on error
set -e

echo "=== $(date) ==="

namespace="{{ namespace | default('ingress-nginx') }}"
nginx_stream_conf_file="/etc/nginx/stream.conf.d/ingress_nginx_load_balancer.conf"
overwrite_flag_path=/tmp/overwrite-flag
overwrite_flag=$(cat $overwrite_flag_path)

current_ip=$(/usr/local/bin/kubectl --kubeconfig /opt/kubeconfig -n $namespace get service ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

update_config() {
  # NOTE: proxmox spawn temporary webserver at port 80 to renew its certificates
  # so we should only listen on https or 443
  # which it's acceptable and prevent insecure http access
  # [UPDATE]: NOPE this will make cert-manager inside k8s cluster fail to issue new certificate using http + ingress
  # so accessing this proxmox will using ssh tunnel (port-forward) to access it or cloudflare tunnel ...
  current_ip=$1

  content='# '$(date --utc +%FT%TZ)' This file '$nginx_stream_conf_file' is generated and will be overwrited
server {
  listen 80;
  proxy_pass '$current_ip':80;
}
server {
  listen 443;
  proxy_pass '$current_ip':443;
}
'

  echo "$content" | tee $nginx_stream_conf_file
}

if [ -z $current_ip ]; then
  echo "invalid current_ip \"$current_ip\""
  echo "exit 1"
  exit 1
fi

previous_ip=$(cat $nginx_stream_conf_file | grep -oP '\d+\.\d+\.\d+\.\d+' | head -n 1)

echo "update nginx config"

if [ $overwrite_flag == "1" ]; then
  echo '$overwrite_flag == "1"'
  update_config $current_ip
  systemctl reload nginx
  echo -n "0" > $overwrite_flag_path
  exit 0
fi

if [ $current_ip == $previous_ip ]; then
  echo "\"$current_ip\" == \"$previous_ip\" (no changes)"
  exit 0
fi

echo "\"$current_ip\" != \"$previous_ip\" (diff)"
echo "update nginx config"

update_config $current_ip
systemctl reload nginx
