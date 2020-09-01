#!/bin/bash

if [ "$#" -lt 1 ]; then 
    echo "[ERROR] you must provide the parameter file's path"
    exit 1
fi

terraform plan \
    -var-file="$1" \
    -out=tf-data/rtf.plan
