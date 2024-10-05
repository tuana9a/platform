#!/bin/bash

set -e

basedir=$(pwd)

for d in [0-9][0-9][0-9]-*; do
    echo $d; cd $d;
    terraform fmt;
    cd $basedir || exit 1;
done
