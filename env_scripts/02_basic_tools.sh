#!/bin/bash

# Function to check if command succeeded
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Update system and install basic tools
sudo apt update
check_command "apt update"

DEBIAN_FRONTEND=noninteractive sudo -E apt-get install --no-install-recommends -qqy \
 apt-utils \
 sudo \
 time \
 tzdata \
 xxd \
 vim \
 xz-utils \
 ca-certificates \
 ssh \
 tar \
 wget \
 curl \
 libcurl4-openssl-dev \
 rsync \
 python3-dev \
 python3-pip \
 cmake \
 make \
 g++ \
 gfortran \
 libopenmpi-dev \
 openmpi-bin \
 units \
 pkg-config \
 valgrind \
 tree \
 libfreetype6-dev \
 git \
 unzip \
 libzstd-dev \
 libncurses5-dev \
 ca-certificates

check_command "install basic tools"

sudo -E apt-get clean
sudo -E rm -fr /var/lib/apt/lists/*

# Symlinks
if [ ! -f "/usr/bin/python" ]; then
  sudo ln -fs /usr/bin/python3 /usr/bin/python
fi
if [ ! -f "/usr/bin/pip" ]; then
  sudo ln -fs /usr/bin/pip3 /usr/bin/pip
fi

# Install Python packages
pip3 --no-cache-dir install wheel setuptools packaging markupsafe Jinja2 edn_format kim-edn kim-property kim-query simplejson numpy scipy matplotlib pymongo montydb pybind11 spglib

check_command "install python packages"

echo "Basic tools installation completed."