#!/bin/bash
set -x

# Installing Nginx
apt install nginx -y

# Enable in systemd
systemctl enable --now nginx

# Setup server block
cat <<EOF >> /etc/nginx/sites-available/swarm_reverse_proxy.conf
server {
    listen 80;
    listen [::]:80;

    server_name dc2.waterviewtechnology.com;
        
    location / {
        proxy_pass http://127.0.0.1:8081;
        include proxy_params;
        
        # header filtering
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        
        # set proxy header  hash size
        proxy_headers_hash_max_size 512;
        proxy_headers_hash_bucket_size 128;
        
    }
}
EOF

# Symlink that shit
ln -s /etc/nginx/sites-available/swarm_reverse_proxy.conf /etc/nginx/sites-enabled/

# Restart NGINX
nginx -t
systemctl restart nginx   
