#!/usr/bin/env bash

set +xe

sudo -i -u root bash << EOF

echo "* Fixing DNS issues on fresh s    tartup of the centos box ..."
sed -i 's/nameserver/#nameserver/g' /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

echo "* Fixing minor repo issues after CentOS8 got dropped out of support ..."
cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

echo "* Update binaries ..."
dnf update -y

echo "* Add hosts ..."
echo "192.168.99.12 centos8 docker" >> /etc/hosts

echo "* Disable/stop firewalld since it does not play well with docker ..."
systemctl disable firewalld
systemctl stop firewalld

echo "* Disable SE Linux ..."
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
 
echo "* Add Docker repository ..."
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 
echo "* Add the missing dependency ..."
dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.1.el7.x86_64.rpm
 
echo "* Install Docker ..."
dnf install -y docker-ce docker-ce-cli
 
echo "* Enable and start Docker ..."
systemctl enable docker
systemctl start docker

################################################
#echo "* Firewall - open port 80 ..."
#firewall-cmd --add-port=80/tcp --permanent

#echo "* Firewall - open port 8080 ..."
#firewall-cmd --add-port=8080/tcp --permanent
 
#echo "* Firewall - set adapter zone ..."
#firewall-cmd --add-interface docker0 --zone trusted --permanent
 
#echo "* Firewall - reload rules ..."
#firewall-cmd --reload
################################################
 
echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant

EOF
