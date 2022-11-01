#!/usr/bin/env bash

set +xe

sudo -i -u root bash << EOF

# Install firewall 
apt-get install ufw -y

# Enable firewall and allow default ports
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

# Create a user to work with
useradd -m -d /home/infra infra

# Set arbirtrary password, recommended to change it later
echo "arfni" | passwd infra

# Set passwordless sudo for created user
echo "infra ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Make sure to purge any previous installations
apt-get remove docker docker-engine docker.io containerd runc && \
rm -rf /var/lib/docker && \
rm -rf /var/lib/containerd

# Update system
apt-get update
apt-get upgrade -y

# Update the apt package index and install packages to allow apt to use a repository over HTTPS
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
# Add Docker’s official GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
# Setup the repo
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \ 
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \ 
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
# Install docker engine
apt-get update

apt-get install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

# Add user to docker group
usermod -aG docker infra

# Enable docker in systemd
systemctl enable docker
systemctl start docker

EOF
