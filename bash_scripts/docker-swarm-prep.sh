#!/bin/bash
set -x

# Define a list of hosts
host_array=("107.175.91.168" "161.129.153.154" "161.129.153.158")

# Generate a RSA key for each node
ssh-keygen -t rsa -N "" -f ~/.ssh/ssh.key

# Add node hosts in /etc/hosts
# Replace IP with actual IPs
echo -e "IP1 docker-slave2" >> /etc/hosts 
echo -e "IP2 docker-master" >> /etc/hosts 
echo -e "IP3 docker-slave1" >> /etc/hosts
#...add as many as you need

# Firewall rules

# ufw allow from 107.175.91.168 to any port 24007:24008/tcp

for str in ${host_array[@]}; do 
  echo $str 
done

needed_ports=("2377/tcp" "7946/tcp" "7946/udp" "4789/ud" "24007:24009/tcp" "nfs" \
              "5667/tcp" "111/tcp" "139/tcp" "445/tcp" "965/tcp" "38465:38469/tcp" \
              "631/tcp" "963/tcp" "49152:49251/tcp")
              
# TCP port 2377 for cluster management communications
# TCP and UDP port 7946 for communication among nodes
# UDP port 4789 for overlay network traffic
# Ports have to be restricted to IPs, to avoid port scanning
ufw allow 2377/tcp
ufw allow 7946/tcp
ufw allow 7946/udp
ufw allow 4789/udp

# Needed for storage persistence
ufw allow 24007:24008/tcp
ufw allow nfs
ufw allow 5667/tcp
ufw allow 111/tcp
ufw allow 139/tcp
ufw allow 445/tcp
ufw allow 965/tcp
ufw allow 38465:38469/tcp
ufw allow 631/tcp
ufw allow 963/tcp
ufw allow 49152:49251/tcp


# Install persistence tool glusterFS
apt install \
  glusterfs-server -y

# Enable in service manager
systemctl start glusterd
systemctl enable glusterd
