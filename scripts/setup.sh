#!/bin/bash

cwd=$PWD
for f in *; do
    if [ $f != "setup.sh" ]; then
        echo $f
        sudo ln -sf $cwd/$f /usr/local/bin/$f
    fi
done
