#!/bin/bash
set -x

# Define a list of hosts
host_array=("161.129.153.154" "107.175.91.168" "161.129.153.158")

# Generate a RSA key for each node
ssh-keygen -t rsa -N "" -f ~/.ssh/ssh.key

# Add node hosts in /etc/hosts
# To use the for cycle you need to correct the arrays if needed
for str in ${host_array[@]}; do 
  echo -e "$str docker-node_${host_array[$i]}" >> /etc/hosts
done

#echo -e "IP1 docker-slave2" >> /etc/hosts 
#echo -e "IP2 docker-master" >> /etc/hosts 
#echo -e "IP3 docker-slave1" >> /etc/hosts
#...add as many as you need

# Firewall rules
# To use the for cycle you need to correct the arrays if needed
# TCP port 2377 for cluster management communications
# TCP and UDP port 7946 for communication among nodes
# UDP port 4789 for overlay network traffic
# Ports have to be restricted to IPs, to avoid port scanning
#ufw allow 2377/tcp
#ufw allow 7946/tcp
#ufw allow 7946/udp
#ufw allow 4789/udp

# Needed for storage persistence
#ufw allow 24007:24008/tcp
#ufw allow nfs
#ufw allow 5667/tcp
#ufw allow 111/tcp
#ufw allow 139/tcp
#ufw allow 445/tcp
#ufw allow 965/tcp
#ufw allow 38465:38469/tcp
#ufw allow 631/tcp
#ufw allow 963/tcp
#ufw allow 49152:49251/tcp

needed_ports_tcp=( \
              "2377" "7946" \
              "24007:24009" \
              "5667" "111" "139" \
              "445" "965" "38465:38469" \
              "631" "963" "49152:49251" \
              )

needed_ports_udp=("7946" "4789")

#TCP ports              
for ip in ${host_array[@]}; do 
  for port in ${needed_ports_tcp[@]}; do
    ufw allow proto tcp from $ip to any port $port
    done
done

#UPD ports
for ip in ${host_array[@]}; do
  for port in ${needed_ports_udp[@]}; do
    ufw allow proto udp from $ip to any port $port
    done
done
             
# Install persistence tool glusterFS
apt install \
  glusterfs-server -y

# Enable in service manager
systemctl start glusterd
systemctl enable glusterd

# Create gluster volume dir
mkdir -p /gluster/swarm_volume1

### Run only from the master node to create the volume accross !!!
### gluster volume create staging-gfs replica 3 docker-master:/gluster/swarm_volume1 docker-slave1:/gluster/swarm_volume1 docker-slave2:/gluster/swarm_volume1 force
### gluster volume start staging-gfs

# Mount the newly created volume in fstab
echo 'localhost:/staging-gfs /mnt glusterfs defaults,_netdev,backupvolfile-server=localhost 0 0' >> /etc/fstab

# Actually mount 
mount.glusterfs localhost:/staging-gfs /mnt

# Change ownership of the mountpoint
chown -R root:docker /mnt

### To use the persistence share, that has just been created place this in your yaml files
### volumes:
###      - type: bind
###        source: /mnt/staging_mysql
###        target: /opt/mysql/data</i>
###

## Source #1: https://thenewstack.io/tutorial-deploy-a-full-stack-application-to-a-docker-swarm/
## Source #2: https://thenewstack.io/tutorial-create-a-docker-swarm-with-persistent-storage-using-glusterfs/
