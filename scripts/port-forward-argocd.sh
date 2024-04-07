#!/bin/bash

address=$1
if [ -z $address ]; then
  echo "usage: port-forward-argocd.sh <bind_address> [port]"
  exit 1
fi

port=$2
if [ -z $port ]; then
  port=8443
fi

kubectl -n argocd port-forward svc/argocd-server --address $address $port:443
