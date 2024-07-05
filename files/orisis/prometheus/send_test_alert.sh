#!/bin/bash

baseUrl=$1

if [ -z $baseUrl ]; then
    baseUrl=http://127.0.0.1:9093
fi

curl -H 'Content-Type: application/json' -d '[{"labels":{"alertname":"test"}}]' /api/v1/alerts