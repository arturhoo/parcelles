#!/bin/bash -eux

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

apt-get install php-pear php5 php5-cgi php5-curl php5-fpm php5-gd php5-idn \
                php5-imagick php5-imap php5-intl php5-mcrypt php5-memcache \
                php5-ming php5-mysql php5-ps php5-pspell php5-recode \
                php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl -q -y

sed "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php5-fpm.sock/" -i \
    /etc/php5/fpm/pool.d/www.conf

if [ $(nginx -t) ]; then
    /etc/init.d/nginx force-reload
fi

/etc/init.d/php5-fpm restart
