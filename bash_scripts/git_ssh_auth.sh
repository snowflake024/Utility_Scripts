#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Git is installed
if ! command_exists git; then
    echo "Git is not installed. Installing Git..."

    # Check if the system is RHEL-based or Debian-based
    if command_exists yum; then
        sudo yum update -y
        sudo yum install git -y
    elif command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install git -y
    else
        echo "Unable to install Git. Please install Git manually and try again."
        exit 1
    fi
fi

# Generate SSH key pair if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    HOST=$(hostname)
    ssh-keygen -t rsa -b 4096 -C "$HOST" -f ~/.ssh/id_rsa -N "" -q
fi

# Start SSH agent
eval "$(ssh-agent -s)"

# Add private key to SSH agent
ssh-add ~/.ssh/id_rsa

# Copy public key to clipboard
command -v xclip >/dev/null 2>&1
if [ $? -eq 0 ]; then
    cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
    echo "Your public key has been copied to the clipboard."
else
    cat ~/.ssh/id_rsa.pub
    echo "Please manually copy your public key and add it to your Git hosting platform."
fi

# Prompt user to add public key to Git hosting platform
echo "Your public key has been copied to the clipboard."
echo "Please go to your Git hosting platform and add the following public key to your SSH settings:"
echo ""
cat ~/.ssh/id_rsa.pub
echo ""
echo "Press Enter to continue once you have added the public key to your Git hosting platform."

# Verify SSH connection
read -s

if ssh -T git@github.com &> /dev/null; then
    echo "SSH connection established successfully."
    echo "Git SSH configuration is complete."
else
    echo "SSH connection failed. Please check your configuration and try again."
fi
