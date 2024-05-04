#!/bin/bash

basedir=$(pwd)

for d in app/* infra/*; do
    echo $d; cd $d;
    terraform fmt;
    cd $basedir || exit 1;
done
