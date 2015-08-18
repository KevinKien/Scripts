#!/bin/bash

# Function Install Nginx On Centos

Nginx_centos() {
    NGINX_VERSION="1.9.0";
    NGINX_MODULE="--user=nginx --group=nginx --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_gzip_static_module --with-http_stub_status_module --with-http_ssl_module --with-pcre --with-file-aio --with-http_realip_module --without-http_scgi_module --without-http_uwsgi_module --without-http_fastcgi_module"

    REPO="
    [nginx]
    name=nginx repo
    baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
    gpgcheck=0
    enabled=1
    "
    
    echo "Install nginx by KevinKien"

    yum install gcc gcc-c++ make zlib-devel pcre-devel openssl-devel wget git

    echo $REPO > /etc/yum.repos.d/nginx.repo

    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
    tar -xvzf nginx-${NGINX_VERSION}.tar.gz
    cd nginx-${NGINX_VERSION}/
    ./configure $NGINX_MODULE
    make
    make install

    useradd -r nginx
    wget -O /etc/init.d/nginx https://gist.github.com/sairam/5892520/raw/b8195a71e944d46271c8a49f2717f70bcd04bf1a/etc-init.d-nginx
    chmod +x /etc/init.d/nginx

    chkconfig --add nginx
    chkconfig --level 345 nginx on

    echo "
----------------------------------------------------------------------------
NGINX COMPLETED INSTALL
Checking the nginx version, should be $NGINX_VERSION and you should see our modules
----------------------------------------------------------------------------
"
    nginx -V

    echo "START NGINX!!"
    /etc/init.d/nginx start
}


# Functions Install Nginx On Ubuntu
Nginx_Ubuntu() {
  NGINX_VERSION="1.9.0";
  NGINX_MODULE="--user=nginx --group=nginx --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_gzip_static_module --with-http_stub_status_module --with-http_ssl_module --with-pcre --with-file-aio --with-http_realip_module --without-http_scgi_module --without-http_uwsgi_module --without-http_fastcgi_module"
  
  echo "Install nginx by KevinKien"
  
  sudo apt-get install build-essential libc6 libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libssl-dev zlib1g zlib1g-dev lsb-base openssl libssl-dev  libgeoip1 libgeoip-dev  google-perftools libgoogle-perftools-dev libperl-dev  libgd2-xpm-dev libatomic-ops-dev libxml2-dev libxslt1-dev python-dev
  
    sudo -s
    nginx=stable # use nginx=development for latest development version
    add-apt-repository ppa:nginx/$nginx
    apt-get update 
  
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
    tar -xvzf nginx-${NGINX_VERSION}.tar.gz
    cd nginx-${NGINX_VERSION}/
    ./configure $NGINX_MODULE
    make
    make install
  
    sudo useradd -r nginx
    wget -O /etc/init.d/nginx http://ctf.ksec.info/nginx-ubuntu
    sudo chmod +x /etc/init.d/nginx

    chkconfig --add nginx
    chkconfig --level 345 nginx on

    echo "
----------------------------------------------------------------------------
NGINX COMPLETED INSTALL
Checking the nginx version, should be $NGINX_VERSION and you should see our modules
----------------------------------------------------------------------------
"
    nginx -V

    echo "START NGINX!!"
    sudo /etc/init.d/nginx start
}

# MAIN

OS=`uname -v | awk '{split($1,array,"-")} END{print array[2]}'`

if [[ $OS == "Ubuntu" ]]
then
    Nginx_Ubuntu
else
    Nginx_centos
fi
