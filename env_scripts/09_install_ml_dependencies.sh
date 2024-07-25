#!/bin/bash

check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Install ML dependencies
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
# check_command "install PyTorch"

pip install pytorch_lightning
check_command "install PyTorch Lightning"

pip install pymatgen==2023.7.20
check_command "install pymatgen"

pip install schema>=0.7.5
check_command "install schema"

pip install einops==0.7.0
check_command "install einops"

pip install e3nn==0.5.1
check_command "install e3nn"

pip install torch-geometric
check_command "install PyTorch Geometric"

pip install torch-scatter -f https://data.pyg.org/whl/torch-2.3.0+cpu.html
check_command "install torch-scatter"

pip install torch-sparse -f https://data.pyg.org/whl/torch-2.3.0+cpu.html
check_command "install torch-sparse"

pip install loguru
check_command "install loguru"

pip install git+https://github.com/ipcamit/kliff.git@wccm
check_command "install kliff"

pip install tensorboard tensorboardX
check_command "install tensorboard"

pip install scikit-learn
check_command "install scikit-learn"

kim-api-collections-management install user TorchML__MD_173118614730_000
check_command "install TorchML KIM model"

echo "ML dependencies installation completed."
