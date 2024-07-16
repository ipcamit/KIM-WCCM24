#!/bin/bash

USER=user

# Copy vim config file
cp external_files/vimrc /home/${USER}/.vimrc

# Copy instructions for pipeline utils into home directory
cp instructions/README.txt /home/${USER}/
chmod 644 /home/${USER}/README.txt

# Copy directories and files
sudo -E cp -r excerpts /pipeline/
sudo -E cp -r tools /pipeline/
sudo -E cp -r utils/bashcompletion /pipeline/
sudo -E cp utils/kimitems /usr/local/bin/
sudo -E cp utils/pipeline-database /usr/local/bin/
sudo -E cp utils/pipeline-find-matches /usr/local/bin/
sudo -E cp utils/pipeline-run-matches /usr/local/bin/
sudo -E cp utils/pipeline-run-pair /usr/local/bin/
sudo -E cp utils/pipeline-run-tests /usr/local/bin/
sudo -E cp utils/pipeline-run-verification-checks /usr/local/bin/
sudo -E cp utils/kimgenie /usr/local/bin/

# Create local repository directory structure
mkdir -p /home/${USER}/{tests,test-drivers,verification-checks,models,model-drivers,simulator-models,test-results,verification-results,errors}

# Create vim directories
mkdir -p /home/${USER}/.vim/{tmp.undo,tmp.backup,tmp.swp}

# Modify .bashrc
cat << EOF >> /home/${USER}/.bashrc

if [[ ":\$LD_LIBRARY_PATH:" != *":/usr/local/lib:"* ]]; then
    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib
fi

if [[ ":\$PYTHONPATH:" != *":/usr/local/lib:"* ]]; then
    export PYTHONPATH=\$PYTHONPATH:/usr/local/lib/python3/dist-packages/
fi

# Disable CMA for inter-rank communication in any MPI processes.
export OMPI_MCA_btl_vader_single_copy_mechanism=none

# Set LAMMPS binary path for ASE
ASE_LAMMPSRUN_COMMAND=/usr/local/bin/lmp

# Enable bashcompletion for local item repository
. /pipeline/bashcompletion

disable_globbing_for_next_command_and_restore() { 
    current_shell_settings="${-}"
    if [[ "${current_shell_settings}" != *"f"* ]]; then
        set -f;
        num_noglob_commands_executed=0
        trapfcn='
            let "++num_noglob_commands_executed"
            if (( $num_noglob_commands_executed == 2 )); then
                set +f
                trap - DEBUG
            fi'
        trap "${trapfcn}" DEBUG
    fi
};

alias kimitems='disable_globbing_for_next_command_and_restore;kimitems';kimitems(){ command kimitems "\$@";set +f;};
alias pipeline-database='disable_globbing_for_next_command_and_restore;pipeline-database';pipeline-database(){ command pipeline-database "\$@";set +f;};
alias pipeline-find-matches='disable_globbing_for_next_command_and_restore;pipeline-find-matches';pipeline-find-matches(){ command pipeline-find-matches "\$@";set +f;};
alias pipeline-run-matches='disable_globbing_for_next_command_and_restore;pipeline-run-matches';pipeline-run-matches(){ command pipeline-run-matches "\$@";set +f;};
alias pipeline-run-pair='disable_globbing_for_next_command_and_restore;pipeline-run-pair';pipeline-run-pair(){ command pipeline-run-pair "\$@";set +f;};
alias pipeline-run-tests='disable_globbing_for_next_command_and_restore;pipeline-run-tests';pipeline-run-tests(){ command pipeline-run-tests "\$@";set +f;};
alias pipeline-run-verification-checks='disable_globbing_for_next_command_and_restore;pipeline-run-verification-checks';pipeline-run-verification-checks(){ command pipeline-run-verification-checks "\$@";set +f;};
EOF

# Assign ownership
sudo -E chown -R ${USER}:${USER} /pipeline/

echo "User environment setup completed."