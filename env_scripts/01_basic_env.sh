#!/bin/bash

# Function to check if command succeeded
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Set up passwordless sudo
echo "Setting up passwordless sudo..."
SUDOER_FILE="/etc/sudoers.d/nopasswd"
CURRENT_USER=$(whoami)

# Check if user already has passwordless sudo
if sudo grep -q "$CURRENT_USER.*NOPASSWD:ALL" /etc/sudoers /etc/sudoers.d/*; then
   echo "Passwordless sudo already set up for $CURRENT_USER"
else
   # Use tee to append to sudoers file
   echo "$CURRENT_USER ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee "$SUDOER_FILE" > /dev/null
   check_command "set up passwordless sudo"
   
   # Set correct permissions on the new sudoers file
   sudo chmod 0440 "$SUDOER_FILE"
   check_command "set correct permissions on sudoers file"
    
   # Verify the change
   sudo visudo -c
   check_command "verify sudoers file"
fi

# Set default encoding to UTF-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Create necessary directories
sudo -E mkdir -p /pipeline/packages/

echo "Environment setup completed."