#!/bin/bash

yum update -y
yum install nginx -y

cat << EOF > /etc/nginx/nginx.conf 
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
  use epoll;
  worker_connections 4096;
}

# Configure strem forwarding of https protocol
stream {
  map $ssl_preread_server_name $backend_pool {
      default $ssl_preread_server_name:$server_port;
      # ~.*\.mulesoft\.com $ssl_preread_server_name:$server_port; # Configure allowed domain names
      # default "";

  }

  server {
    listen 443;
    listen 5044; # Log Forwarding port
    ssl_preread on;
    resolver 8.8.8.8;
    proxy_pass $backend_pool;
  }
}

# With opposing http Association Protocol trans to the generation of Li
http {

  log_format main '$remote_addr - $remote_user [$time_local] $host$request_uri "$request" '
  '$status $body_bytes_sent "$http_referer" '
  '"$http_user_agent" "$http_x_forwarded_for"';

  access_log /var/log/nginx/access.log main;

  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  gzip  on ;
  gzip_comp_level 6;
  gzip_http_version 1.1;
  gzip_proxied any;
  gzip_min_length 1k;
  gzip_buffers 16 8k;
  gzip_types text/plain text/css text/javascript application/json application/javascript application/x-javascript application/xml;
  gzip_vary on;
  #end gzip

  client_max_body_size 10m; client_body_buffer_size 128k;

  proxy_buffer_size 128k;
  proxy_buffers 32 64k;
  proxy_busy_buffers_size 256k;
  proxy_connect_timeout 60;
  proxy_send_timeout 60;
  proxy_read_timeout 60;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  include /etc/nginx/conf.d/*.conf;

  server {

    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;
    location / {

	    set $is_allow 0;

      if ($host ~ '.*\.amazonaws\.com') {
          set $is_allow 1;
      }
      if ($host ~ '.*\.mulesoft\.com') {
          set $is_allow 1;
      }
      if ($host ~ '.*\.googleapis\.com') {
          set $is_allow 1;
      }
      if ($host ~ '.*\.msap\.io') {
          set $is_allow 1;
      }
      if ($host ~ '.*\.cloudhub\.io') {
          set $is_allow 1;
      }
      if ($is_allow = 0) {
          return 404;
      }

      proxy_set_header Host $host;
      proxy_set_header Accept-Encoding "";
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Cookie $http_cookie;

      resolver 8.8.8.8;
      proxy_pass http://$host:$server_port$request_uri;
    }

  }
}
EOF

systemctl start nginx
systemctl enable nginx

