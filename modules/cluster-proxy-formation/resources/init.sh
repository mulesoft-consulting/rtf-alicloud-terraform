#!/bin/bash

yum update -y
yum group install "Development Tools" -y
yum -y install pcre pcre-devel zlib zlib-devel openssl openssl-devel git
NGINX_VERSION="1.15.2"
NGINX_CONNECT_PATCH="proxy_connect_rewrite_1015.patch"

curl -L "http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" --out nginx-$NGINX_VERSION.tar.gz
git clone git://github.com/chobits/ngx_http_proxy_connect_module.git

tar -xzvf nginx-$NGINX_VERSION.tar.gz
cd "nginx-$NGINX_VERSION"
patch -p1 < "../ngx_http_proxy_connect_module/patch/$NGINX_CONNECT_PATCH"

chmod +x configure

./configure \
 --user=root \
 --group=root \
 --prefix=/usr/local/nginx \
 --with-http_ssl_module \
 --with-stream \
 --with-stream_ssl_preread_module \
 --with-http_stub_status_module \
 --with-http_realip_module \
 --with-threads \
 --add-module=../ngx_http_proxy_connect_module/

make && make install

echo 'PATH=$PATH:/usr/local/nginx/sbin; export PATH' >> ~/.bash_profile

cat << 'EOF' > /usr/local/nginx/conf/nginx.conf 
${nginx_conf}
EOF

cat << 'EOF' > /etc/init.d/nginx
${nginx_initd}
EOF

chmod 755 /etc/init.d/nginx
chkconfig --add nginx

killall -9 nginx

systemctl enable nginx
systemctl start nginx
