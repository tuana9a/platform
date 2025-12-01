#!/bin/sh

set -exu

sleep 5

# Set the DNS servers for eth0
/usr/bin/resolvectl dns eth0 1.1.1.1 8.8.8.8
