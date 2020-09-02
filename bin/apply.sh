#!/bin/bash

if [ "$#" -lt 1 ]; then 
    echo "[ERROR] you must provide the parameter file's path"
    exit 1
fi

if [ "$#" -eq 1 ]; then
    terraform apply \
        -var-file="$1" \
        -state=tf-data/rtf.tfstate
fi

if [ "$#" -eq 2 ]; then
    terraform apply \
        -var-file="$1" \
        -target="$2" \
        -state=tf-data/rtf.tfstate
fi


