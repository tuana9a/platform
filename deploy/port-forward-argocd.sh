#!/bin/bash

kubectl -n argocd port-forward svc/argocd-server 8443:443 --address localhost
