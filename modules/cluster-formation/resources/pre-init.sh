#!/bin/bash

# PARAMETERS
PROXY="${proxy_url}"
SCRIPTS_URL="${installer_scripts_url}"
SLEEP_DURATION=20     #sleep durantion in seconds
RTF_FOLDER='/opt/anypoint/runtimefabric'

echo "*************************************"
echo "* RTF/Alibaba initialization begin. *"
echo "*************************************"

echo "* Installing system dependencies..."
yum update -y
yum install unzip -y

# ACTIVATE THE PROXY FOR CURL (IF APPLICABLE)
# INTRODUCING A LITTLE DELAY TO LET THE PROXY INIT
if [ ! -z "$PROXY" ]; then 
  echo "* Waiting $SLEEP_DURATION seconds before activating proxy"
  sleep "$SLEEP_DURATION"
  echo -n "* Activating http proxy..."
  export http_proxy="$PROXY"
  export https_proxy="$PROXY"
  echo "done"
fi

# Downloading installer scripts
echo "* Downloading RTF scripts..."
curl -L $SCRIPTS_URL  --output ~/rtf-install-scripts.zip

# DEACTIVATING PROXY FOR CURL
export http_proxy=""
export https_proxy=""

# EXTRACTING  
echo "* Extracting scripts from RTF zip file..."
mkdir -p $RTF_FOLDER
mkdir -p ~/rtf-install-scripts 
unzip ~/rtf-install-scripts.zip -d ~/rtf-install-scripts
cp ~/rtf-install-scripts/scripts/init.sh "$RTF_FOLDER/init.sh" 
chmod +x "$RTF_FOLDER/init.sh"

echo "* Executing runtimefabrice init.sh script..."
/bin/bash /opt/anypoint/runtimefabric/init.sh
