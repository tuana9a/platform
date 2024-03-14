#!/bin/bash

opts=""

if [ ! -z $BIND_ADDRESS ]; then
  opts="--address $BIND_ADDRESS"
fi

kubectl -n argocd port-forward svc/argocd-server 8443:443 $opts
