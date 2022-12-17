#!/bin/bash
set -x

DOMAIN=$1


# Install certbot
apt install certbot python3-certbot-nginx -y

# Secure a certain domain
certbot --nginx -d $DOMAIN
