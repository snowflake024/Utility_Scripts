#!/bin/bash
set -x

# Install certbot
apt install certbot python3-certbot-nginx -y

# Secure a certain domain
certbot --nginx -d YOUR_DOMAIN_HERE
