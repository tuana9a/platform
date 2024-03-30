#!/bin/bash

port="{{ port | default('8080') }}"
bind_address="{{ bind_address | default('0.0.0.0') }}"

export KUBECONFIG="{{ kubeconfig }}"

kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller $port:80 --address $bind_address
