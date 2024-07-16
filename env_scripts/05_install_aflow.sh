#!/bin/bash

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

cd /pipeline/packages
sudo -E wget -q http://materials.duke.edu/AFLOW/aflow.3.2.14.tar.xz
sudo -E tar xJf aflow.3.2.14.tar.xz
sudo -E rm aflow.3.2.14.tar.xz
cd aflow.3.2.14
sudo -E make -j$(nproc) aflow

check_command "build AFLOW"

sudo -E cp aflow /usr/local/bin
sudo -E touch /usr/local/bin/aflow_data
sudo -E chmod +x /usr/local/bin/aflow_data
cd /pipeline/packages
sudo -E rm -r aflow.3.2.14

check_command "install AFLOW"

echo "AFLOW installation completed."