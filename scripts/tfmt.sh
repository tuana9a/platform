#!/bin/bash

for d in $(ls -d *); do echo $d; cd $d; terraform fmt; cd ..; done
