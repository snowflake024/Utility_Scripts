#!/bin/bash
set -x

# Add node hosts in /etc/hosts
echo "IP1" >> /etc/host
echo "IP2" >> /etc/host
echo "IP3" >> /etc/host

# Firewall rules
# TCP port 2377 for cluster management communications
# TCP and UDP port 7946 for communication among nodes
# UDP port 4789 for overlay network traffic
ufw allow 2377/tcp
ufw allow 7946/tcp
ufw allow 7946/udp
ufw allow 4789/udp

