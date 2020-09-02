#!/bin/bash

yum update -y
yum install nginx -y

cat << 'EOF' > /etc/nginx/nginx.conf 
${nginx_conf}
EOF

systemctl start nginx
systemctl enable nginx
systemctl restart nginx
