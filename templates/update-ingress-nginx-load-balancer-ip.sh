#!/bin/bash

echo "=== $(date) ==="

export KUBECONFIG="{{ kubeconfig }}"

ip_file=/tmp/current-ingress-nginx-load-balancer-ip.txt

if [ ! -f $ip_file ]; then
  touch $ip_file
fi

ip=$(kubectl get -n ingress-nginx service ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z $ip ]; then
  echo "\"$previous_ip\" -> \"$ip\", invalid ip, exiting..."
  exit 1
fi

previous_ip=$(cat $ip_file)

if [ $previous_ip == $ip ]; then
  echo "\"$previous_ip\" -> \"$ip\", no changes, exiting..."
  exit 0
fi

echo "\"$previous_ip\" -> \"$ip\", diff detected, updating nginx config..."
echo $ip > $ip_file

echo "# DO NOT EDIT, this file is generated
server {
  listen 8080;
  proxy_pass ${ip}:80;
}
server {
  listen 8443;
  proxy_pass ${ip}:443;
}
" | sudo tee /etc/nginx/stream.conf.d/ingress_nginx_load_balancer.conf

sudo systemctl reload nginx
