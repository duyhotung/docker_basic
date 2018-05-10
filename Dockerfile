############################################################
# Dockerfile to build NewBiz container images
# Based on AmazonLinux
############################################################

# Set the base image to AmazonLinux
FROM amazonlinux:latest
MAINTAINER DuyHo

################## BEGIN INSTALLATION ######################

ADD create-user.sh /tmp/create-user.sh
ADD server-config.sh /tmp/server-config.sh
ADD 10-php.conf /etc/httpd/conf.modules.d/10-php.conf
ADD php.conf /etc/httpd/conf.d/php.conf
ADD create-env.sh /tmp/create-env.sh
ADD start-servers.sh /usr/sbin/start-servers


RUN yum update -y && yum install -y \
sudo \
httpd24 \
httpd24-devel \
gcc \
libxml2-devel \
openssl-devel \
libcurl-devel \
autoconf \
mysql57 \
mysql57-server \
wget \
php71 \
yum \
git \
&& yum clean all

# Install Php7.2.4
RUN wget -O php-7.2.4.tar.gz http://jp2.php.net/get/php-7.2.4.tar.gz/from/this/mirror \
&& tar -xzpvf php-7.2.4.tar.gz \
&& cd php-7.2.4 \
&& ./configure --with-apxs2=/usr/bin/apxs --with-zlib-dir --with-zlib --enable-mysqlnd --enable-mbstring --with-pdo-mysql --with-mysqli --with-mysql-sock=/var/run/mysqld/mysqld.sock --with-curl=/usr/bin/curl --with-openssl \
&& make \
&& make install \
&& cp php.ini-production /usr/local/lib/php.ini \
&& mv /usr/bin/php /usr/bin/php.bk \
&& ln -s /usr/local/bin/php /usr/bin/php

# Install Xdebug 2.6
RUN cd .. \
&& wget http://xdebug.org/files/xdebug-2.6.0.tgz \
&& tar -xzpvf xdebug-2.6.0.tgz \
&& cd xdebug-2.6.0 \
&& phpize \
&& ./configure \
&& make \
&& cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718 \
&& echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so" >> /usr/local/lib/php.ini

# Install Composer
RUN cd .. && /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php && mv composer.phar /usr/bin/composer

# Install Phan
RUN wget -O ast-0.1.6.tgz http://pecl.php.net/get/ast \
&& tar -xzpvf ast-0.1.6.tgz \
&& cd ast-0.1.6 \
&& phpize \
&& ./configure \
&& make \
&& make install \
&& echo "extension=ast.so" >> /usr/local/lib/php.ini

EXPOSE 80
EXPOSE 443
EXPOSE 3306


RUN /bin/bash /tmp/create-user.sh && \
rm /tmp/create-user.sh && \
/bin/bash /tmp/server-config.sh && \
rm /tmp/server-config.sh && \
/bin/bash /tmp/create-env.sh && \
rm /tmp/create-env.sh

CMD /usr/bin/env bash start-servers;sleep infinity
