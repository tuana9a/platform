#!/bin/bash

# exit on error
set -e

while getopts "f" o; do
  case "${o}" in
    f)
      is_forced="yes"
      ;;
    *)
      echo "Unknown"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

nginx_stream_conf_file="/etc/nginx/stream.conf.d/ingress_nginx_load_balancer.conf"

new_ip=$1

update_config() {
  # NOTE: proxmox spawn temporary webserver at port 80 to renew its certificates
  # so we should only listen on https or 443, which it's acceptable and prevent insecure http access
  # UPDATE: this will make cert-manager inside k8s cluster fail to issue new certificate using http + ingress
  # so accessing this proxmox will using ssh tunnel (port-forward) to access it or cloudflare tunnel ...
  new_ip=$1
  content='# This file '$nginx_stream_conf_file' is generated
# '$(date --utc +%FT%TZ)'
server {
  listen 80;
  proxy_pass '$new_ip':80;
}
server {
  listen 443;
  proxy_pass '$new_ip':443;
}
'

  echo "$content" | tee $nginx_stream_conf_file
}

if [ -z "$new_ip" ]; then
  echo "invalid new_ip $new_ip"
  echo "exit 1"
  exit 1
fi

current_ip="9.9.9.9"
if [ -f "$nginx_stream_conf_file" ]; then
  current_ip=$(cat $nginx_stream_conf_file | grep -oP '\d+\.\d+\.\d+\.\d+' | head -n 1)
fi

if [ "$is_forced" == "yes" ]; then
  echo "forced update"
  update_config "$new_ip"
  systemctl reload nginx
  exit 0
fi

if [ "$new_ip" == "$current_ip" ]; then
  echo "same: \"$new_ip\" == \"$current_ip\""
  exit 0
fi

echo "diff: \"$new_ip\" != \"$current_ip\""
update_config "$new_ip"
systemctl reload nginx
exit 0