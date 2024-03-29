#!/bin/bash

opts=""
port=8443

if [ ! -z $PORT ]; then
  port=$PORT
fi

if [ ! -z $BIND_ADDRESS ]; then
  opts="--address $BIND_ADDRESS"
fi

kubectl -n argocd port-forward svc/argocd-server $port:443 $opts
