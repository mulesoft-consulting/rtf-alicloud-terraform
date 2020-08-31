#!/bin/bash

yum update -y
yum install unzip -y

RTF_FOLDER='/opt/anypoint/runtimefabric'
mkdir -p $RTF_FOLDER

curl -L "${installer_scripts_url}"  --output ~/rtf-install-scripts.zip

mkdir -p ~/rtf-install-scripts 
unzip ~/rtf-install-scripts.zip -d ~/rtf-install-scripts

cp ~/rtf-install-scripts/scripts/init.sh "$RTF_FOLDER/init.sh" 
chmod +x "$RTF_FOLDER/init.sh"

/bin/bash /opt/anypoint/runtimefabric/init.sh
