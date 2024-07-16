#!/bin/bash

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

cd /pipeline/packages
sudo -E wget -q https://s3.openkim.org/kim-api/kim-api-2.3.0.txz 
sudo -E tar xJf kim-api-2.3.0.txz 
sudo -E rm kim-api-2.3.0.txz
cd kim-api-2.3.0
sudo -E mkdir build && cd build
sudo -E cmake .. -DCMAKE_BUILD_TYPE=Release
sudo -E make -j$(nproc) 

check_command "build KIM API"

sudo -E make install
cd /pipeline/packages
sudo -E cp kim-api-2.3.0/build/install_manifest.txt kim_api_install_manifest.txt
sudo -E rm -r kim-api-2.3.0
sudo -E ldconfig

check_command "install KIM API"

echo "KIM API installation completed."

sudo -E git config --global --add safe.directory /pipeline/packages/numdifftools

sudo -E git clone -q https://github.com/openkim/numdifftools -b master /pipeline/packages/numdifftools
cd /pipeline/packages/numdifftools \
  && git checkout a53debb144ed02c5c6eb74d5c18d53058259f27c
cd /pipeline/packages/

sudo -E git config --global --add safe.directory /pipeline/packages/kim-python-utils

sudo -E git clone -q https://github.com/openkim/kim-python-utils -b master /pipeline/packages//kim-python-utils
cd /pipeline/packages//kim-python-utils \
  && git checkout e4e21b202264373a9f33dfc47b6e05c0af625950
cd /pipeline/packages/
  
sudo -E git config --global --add safe.directory /pipeline/packages/crystal-genome-util

sudo -E git clone -q https://github.com/openkim/crystal-genome-util -b main /pipeline/packages//crystal-genome-util
cd /pipeline/packages//crystal-genome-util \
  && git checkout e18a2d62fc3e391acbf9c98a28efaebca914b007
cd /pipeline/packages/

sudo -E git config --global --add safe.directory /pipeline/packages/lammps
sudo -E git clone -q https://github.com/lammps/lammps -b stable_2Aug2023_update1 /pipeline/packages//lammps

sudo -E git config --global --add safe.directory /pipeline/packages/ase
sudo -E git clone -q https://gitlab.com/openkim/ase -b user-species /pipeline/packages//ase \
  && cd /pipeline/packages//ase \
  && git checkout abe2d6c6e265f7ba6e79cc9b437ef1940731eccc

sudo -E git config --global --add safe.directory /pipeline/packages/MD++
sudo -E git clone -q https://gitlab.com/micronano_public/MDpp -b release /pipeline/packages//MD++ \
  && cd /pipeline/packages//MD++ \
  && git checkout f7d64a7720a4bc1602371a128c8db7779fcf8dcb

sudo -E git config --global --add safe.directory /pipeline/packages/kim-tools
sudo -E git clone -q https://github.com/openkim/kim-tools -b main /pipeline/packages//kim-tools \
  && cd /pipeline/packages//kim-tools \
  && git checkout 003b84fdab9f955c607816fbbe3827c3ae3a4bc7
cd /pipeline/packages/

#########################################
## numdifftools
#########################################
cd /pipeline/packages/numdifftools
sudo -E pip --no-cache-dir install . 

check_command "install numdifftools"
#########################################
## kimpy
#########################################
# NOTE: Must be installed after KIM API
pip --no-cache-dir install kimpy==2.1.0
