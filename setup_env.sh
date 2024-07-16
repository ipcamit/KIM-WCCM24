#!/bin/bash

SCRIPTS=(
"env_scripts/01_basic_env.sh"
"env_scripts/02_basic_tools.sh"
"env_scripts/03_install_kim_lammps.sh"
"env_scripts/04_install_lammps.sh"
"env_scripts/05_install_aflow.sh"
"env_scripts/06_setup_pipeline.sh"
"env_scripts/07_install_llvm_libtorch.sh"
"env_scripts/08_install_enzyme.sh"
"env_scripts/09_install_ml_dependencies.sh"
)

export cwd=$(pwd)

for script in "${SCRIPTS[@]}"; do
    echo "Running $script..."
    if ! bash "$script"; then
        echo "Error in $script. Installation halted."
        echo "Fix the issue and rerun the master script to continue from this point."
        exit 1
    fi
    echo "Completed $script."
    cd $cwd
done

echo "Installation completed successfully!"