#!/bin/bash

if [ "$#" -lt 1 ]; then 
    echo "[ERROR] you must provide the parameter file's path"
    exit 1
fi

terraform apply \
    -var-file="$1" \
    -state=tf-data/rtf.tfstate
