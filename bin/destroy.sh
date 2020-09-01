#!/bin/bash

if [ "$#" -lt 2 ]; then 
    echo "[ERROR] you must provide the parameter file's path"
    exit 1
fi

terraform destroy \
    -var-file="$1" \
    -target="$2" \
    -state=tf-data/rtf.tfstate
