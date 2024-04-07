#!/bin/bash

address=$1
if [ -z $address ]; then
  echo "usage: port-forward-ingress-nginx.sh <bind_address> [port]"
  exit 1
fi

port=$2
if [ -z $port ]; then
  port=8443
fi

kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller --address $address $port:80
