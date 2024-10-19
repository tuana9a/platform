#!/bin/bash

echo "=== $(date) ==="

export KUBECONFIG="{{ kubeconfig }}"
namespace="{{ namespace | default('ingress-nginx') }}"
ip_file=/tmp/current-ingress-nginx-load-balancer-ip.txt

if [ ! -f $ip_file ]; then
  touch $ip_file
fi

ip=$(kubectl get -n $namespace service ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z $ip ]; then
  echo "\"$previous_ip\" -> \"$ip\", invalid ip, exiting..."
  exit 1
fi

previous_ip=$(cat $ip_file)

if [ $previous_ip == $ip ]; then
  echo "\"$previous_ip\" -> \"$ip\", no changes, exiting..."
  exit 0
fi

echo "\"$previous_ip\" -> \"$ip\", diff detected, updating nginx config "
echo -n $ip > $ip_file

echo "# This file is generated and will be overwrited
# /etc/nginx/stream.conf.d/ingress_nginx_load_balancer.conf
# $(date)
server {
  listen 80;
  proxy_pass ${ip}:80;
}
server {
  listen 443;
  proxy_pass ${ip}:443;
}" | sudo tee /etc/nginx/stream.conf.d/ingress_nginx_load_balancer.conf

sudo systemctl reload nginx
