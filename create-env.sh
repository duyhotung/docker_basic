#!/usr/bin/env bash

mkdir /etc/httpd/conf.d/vhosts
chmod -R 0755 /etc/httpd/conf.d/vhosts
echo "IncludeOptional conf.d/vhosts/*.conf" >> /etc/httpd/conf/httpd.conf

