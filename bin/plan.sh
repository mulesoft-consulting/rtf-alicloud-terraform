#!/bin/bash

if [ "$#" -lt 1 ]; then 
    echo "[ERROR] you must provide the parameter file's path"
    exit 1
fi

if [ "$#" -eq 1 ]; then
    terraform plan \
        -var-file="$1" \
        -out=tf-data/rtf.plan
fi

if [ "$#" -eq 2 ]; then
    terraform plan \
        -var-file="$1" \
        -target="$2" \
        -out=tf-data/rtf.plan
fi


