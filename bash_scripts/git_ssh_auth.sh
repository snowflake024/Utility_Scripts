#!/bin/bash

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Installing Git..."
    sudo apt update
    sudo apt install git -y
fi

# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add private key to SSH agent
ssh-add ~/.ssh/id_rsa

# Copy public key to clipboard
cat ~/.ssh/id_rsa.pub | pbcopy

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
