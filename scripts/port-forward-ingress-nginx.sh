#!/bin/bash

opts=""
port=8080

if [ ! -z $PORT ]; then
  port=$PORT
fi

if [ ! -z $BIND_ADDRESS ]; then
  opts="--address $BIND_ADDRESS"
fi

kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller $port:80 $opts
