#!/bin/bash

opts=""

if [ ! -z $BIND_ADDRESS ]; then
  opts="--address $BIND_ADDRESS"
fi

kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80 $opts
