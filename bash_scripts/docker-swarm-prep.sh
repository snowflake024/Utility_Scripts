#!/bin/bash
set -x

# Generate a RSA key for each node
ssh-keygen -t rsa -N "" -f ~/.ssh/ssh.key

# Add node hosts in /etc/hosts
# Replace IP with actual IPs
echo -e "IP1 docker-slave2" >> /etc/hosts 
echo -e "IP2 docker-master" >> /etc/hosts 
echo -e "IP3 docker-slave1" >> /etc/hosts
#...add as many as you need

# Firewall rules
# TCP port 2377 for cluster management communications
# TCP and UDP port 7946 for communication among nodes
# UDP port 4789 for overlay network traffic
ufw allow 2377/tcp
ufw allow 7946/tcp
ufw allow 7946/udp
ufw allow 4789/udp

# Install persistence tool glusterFS
apt install \
  glusterfs-server -y

# Enable in service manager
systemctl start glusterd
systemctl enable glusterd
