#!/usr/bin/env bash

set +xe

sudo -i -u root bash << EOF

# Create a user to work with
useradd -m -d /home/infra infra

# Set arbirtrary password, recommended to change it later
echo "arfni" | passwd infra

# Set passwordless sudo for created user
echo "infra ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
