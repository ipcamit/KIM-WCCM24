#!/bin/bash

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Install Enzyme
git clone https://github.com/enzymead/enzyme
cd enzyme/enzyme
git checkout v0.0.100
mkdir build && cd build
CC=/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/bin/clang CXX=/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/bin/clang++  cmake .. -DLLVM_DIR=/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/lib/cmake/llvm
make -j$(nproc)
check_command "build Enzyme"
sudo make install
check_command "install Enzyme"
cd ../../..
echo "Enzyme installation completed."

# Compile and copy libdescriptor
# Eigen
sudo cp -r Eigen /usr/local/include

cd libdescriptor 
/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/bin/clang++ -shared -fPIC Descriptors.cpp -Xclang -load -Xclang /usr/local/lib/ClangEnzyme-17.so -O3 -o libdescriptor.so -I/usr/local/include
check_command "build libdescriptor"

# install
sudo cp libdescriptor.so /usr/local/lib
cd ../libdescriptor_include # use lighter header file
sudo cp Descriptors.hpp /usr/local/include
cd ..

echo "libdescriptor installation completed."

# install python extensions
cd libdescriptor_py
python setup.py build_ext --inplace
check_command "build libdescriptor python extensions"
python setup.py install
check_command "install libdescriptor python extensions"
