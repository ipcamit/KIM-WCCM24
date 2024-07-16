#!/bin/bash

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

cd /pipeline/packages/lammps/
sudo -E mkdir build
cd build
DEBIAN_FRONTEND=noninteractive sudo -E cmake \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local/ \
      -D CMAKE_TUNE_FLAGS="-march=x86-64 -mtune=generic" \
      -D BUILD_SHARED_LIBS=yes \
      -D BUILD_MPI=yes \
      -D LAMMPS_EXCEPTIONS=yes \
      -D PKG_KIM=yes \
      -D PKG_KSPACE=yes \
      -D PKG_MANYBODY=yes \
      -D PKG_MOLECULE=yes \
      -D PKG_CLASS2=yes \
      -D PKG_PYTHON=yes \
      -D PKG_ML-SNAP=yes \
      -D PKG_MGPT=yes \
      -D PKG_MEAM=yes \
      -D PKG_REAXFF=yes \
      -D PKG_MISC=yes \
      -D PKG_SMTBQ=yes \
      -D PKG_EXTRA-PAIR=yes \
      -D PKG_CORESHELL=yes \
      -D PKG_EXTRA-FIX=yes \
      ../cmake 
sudo -E make -j$(nproc)

check_command "build LAMMPS"

sudo -E make install 
sudo -E apt-get update -qq 
sudo -E apt-get install --no-install-recommends -qqy python3-venv 
sudo -E make install-python 
sudo -E apt-get purge -y python3-venv 
sudo -E apt-get clean 
sudo -E rm -fr /var/lib/apt/lists/* 
sudo -E ln -s /usr/local/bin/lmp /usr/local/bin/lammps 
sudo -E rm -r /usr/local/share/lammps/potentials
cd /pipeline/packages 
sudo -E rm -r /pipeline/packages/lammps

check_command "install LAMMPS"

echo "LAMMPS installation completed."

#########################################
## MD++
#########################################
# Alterations we make to install MD++
# 1. Change "SPEC = " -> "SPEC = -DNO_X11" in makefile
# 2. Change "TCL = yes" -> "TCL = no" in src/Makefile
# 3. Change "XLIBS=$(XLIBS.$(SYS))" -> "XLIBS=" in src/Makefile.base
cd /pipeline/packages/MD++
sudo -E mkdir bin 
sudo -E sed -i 's/SPEC = /SPEC = -DNO_X11/g' makefile 
sudo -E sed -i 's/TCL = yes/TCL = no/g' src/Makefile 
sudo -E sed -i 's/XLIBS=$(XLIBS.$(SYS))/XLIBS=/g' src/Makefile.base 
sudo -E make -j$(nproc) md build=R 

check_command "build MD++"

sudo -E cp bin/md_gpp /usr/local/bin 
cd /pipeline/packages 
sudo -E rm -r MD++

check_command "install MD++"

#########################################
## OpenKIM ASE fork
#########################################
cd /pipeline/packages/ase/
sudo -E pip --no-cache-dir install .

check_command "install OpenKIM ASE fork"
#########################################
## kim-python-utils
#########################################
cd /pipeline/packages/kim-python-utils 
sudo -E pip --no-cache-dir install .

check_command "install kim-python-utils"
#########################################
## crystal-genome-util
#########################################
cd /pipeline/packages/crystal-genome-util
sudo -E pip --no-cache-dir install .

check_command "install crystal-genome-util"
#########################################
## kim-tools
#########################################
cd /pipeline/packages/kim-tools
sudo -E pip --no-cache-dir install .

check_command "install kim-tools"