#!/bin/bash

MOUNT=$1
EMAIL=$2
CURRENT=$(df | grep "$MOUNT" | awk '{ print $4}' | sed 's/%//g')
THRESHOLD=90

if [ "$CURRENT" -gt "$THRESHOLD" ]
then
    mail -s 'Disk Space Alert' $EMAIL << EOF
                Your root partition remaining free space is critically low. Used: $CURRENT%.
EOF
fi
