#!/bin/bash

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Install LLVM 17
cd /opt
sudo wget https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04.tar.xz
check_command "download LLVM"
sudo tar -xvf clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04.tar.xz
check_command "extract LLVM"

# Set environment variables for LLVM
echo 'export PATH="/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/bin:$PATH"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
echo 'export INCLUDE="/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/include:$INCLUDE"' >> ~/.bashrc

# Install libtorch (CPU version)
sudo wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.13.0%2Bcpu.zip
check_command "download libtorch"
sudo unzip libtorch-cxx11-abi-shared-with-deps-1.13.0+cpu.zip -d /opt
check_command "extract libtorch"

# Set environment variables for libtorch
echo 'export PATH="/opt/libtorch/bin:$PATH"' >> ~/.bashrc
# echo 'export LD_LIBRARY_PATH="/opt/libtorch/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc # To add only manually when needed else python segfaults
echo 'export INCLUDE="/opt/libtorch/include:$INCLUDE"' >> ~/.bashrc
echo 'export Torch_ROOT="/opt/libtorch"' >> ~/.bashrc
echo 'export TORCH_ROOT="/opt/libtorch"' >> ~/.bashrc

# Set environment variables for current session
export PATH="/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/bin:/opt/libtorch/bin:$PATH"
export LD_LIBRARY_PATH="/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/lib:$LD_LIBRARY_PATH"
export INCLUDE="/opt/clang+llvm-17.0.5-x86_64-linux-gnu-ubuntu-22.04/include:/opt/libtorch/include:$INCLUDE"
export Torch_ROOT="/opt/libtorch"
export TORCH_ROOT="/opt/libtorch"

echo "LLVM and libtorch installation completed."

current_dir=$(pwd)

# Check for CUDA
# if ! command -v nvcc &> /dev/null
# then
#     echo "Info: CUDA not found, installing CPU version of dependencies"
#     is_cuda_available=0
# else
#     echo "Info: CUDA found, installing GPU version of dependencies"
#     is_cuda_available=1
#     if [[ -z "${CUDNN_ROOT}" ]]; then
#         echo "Error: CUDNN_ROOT env variable not found. Please set it to your CUDNN installation location."
#         exit 1
#     else
#         echo "Info: Located CUDNN at ${CUDNN_ROOT}"
#     fi
# fi

# Install TorchScatter
if [[ -z "${TorchScatter_ROOT}" ]]; then
    echo "Installing TorchScatter"
    git clone --recurse-submodules https://github.com/rusty1s/pytorch_scatter || exit
    mkdir -p build_scatter
    cd build_scatter || exit
    if [[ $is_cuda_available -eq 1 ]]; then
        cmake -DCMAKE_PREFIX_PATH="${TORCH_ROOT}" -DCMAKE_INSTALL_PREFIX="" -DCUDNN_INCLUDE_PATH="${CUDNN_ROOT}/include" -DCUDNN_LIBRARY_PATH="${CUDNN_ROOT}/lib" -DCMAKE_BUILD_TYPE=Release ../pytorch_scatter || exit
    else
        cmake -DCMAKE_PREFIX_PATH="${TORCH_ROOT}" -DCMAKE_INSTALL_PREFIX="" -DCMAKE_BUILD_TYPE=Release ../pytorch_scatter || exit
    fi
    sudo make -j$(nproc) install
    check_command "install TorchScatter"
    cd ${current_dir} || exit
else
    echo "Info: Located TorchScatter at ${TorchScatter_ROOT}"
fi

# Install TorchSparse
if [[ -z "${TorchSparse_ROOT}" ]]; then
    echo "Installing TorchSparse"
    git clone --recurse-submodules https://github.com/rusty1s/pytorch_sparse || exit
    mkdir -p build_sparse
    cd build_sparse || exit
    if [[ $is_cuda_available -eq 1 ]]; then
        cmake -DCMAKE_PREFIX_PATH="${TORCH_ROOT}" -DCMAKE_INSTALL_PREFIX="" -DCUDNN_INCLUDE_PATH="${CUDNN_ROOT}/include" -DCUDNN_LIBRARY_PATH="${CUDNN_ROOT}/lib" -DCMAKE_BUILD_TYPE=Release ../pytorch_sparse || exit
    else
        cmake -DCMAKE_PREFIX_PATH="${TORCH_ROOT}" -DCMAKE_INSTALL_PREFIX="" -DCMAKE_BUILD_TYPE=Release ../pytorch_sparse || exit
    fi
    sudo make -j$(nproc) install
    check_command "install TorchSparse"
    cd ${current_dir} || exit
else
    echo "Info: Located TorchSparse at ${TorchSparse_ROOT}"
fi

echo "TorchScatter and TorchSparse installation completed."
