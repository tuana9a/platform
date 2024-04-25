#!/bin/bash

echo "usage: port-forward-argocd.sh <bind_address> [port]"

address=$1
if [ -z $address ]; then
  address="127.0.0.1"
fi

port=$2
if [ -z $port ]; then
  port=8443
fi

echo bind $address:$port

kubectl -n argocd port-forward svc/argocd-server --address $address $port:443
