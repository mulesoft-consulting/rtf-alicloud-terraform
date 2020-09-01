#!/bin/bash

if [ "$#" -lt 2 ]; then 
    echo "[ERROR] you must provide the parameter file's path"
    exit 1
fi

terraform plan \
    -var-file="$1" \
    -target="$2" \
    -out=tf-data/rtf.plan
