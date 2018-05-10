#!/usr/bin/env bash

service httpd stop
service mysqld stop

if [ -e /var/run/httpd/httpd.pid ]
then
	rm -f /var/run/httpd/httpd.pid
fi

if [ -e /var/run/mysqld/mysqld.pid ]
then
	rm -f /var/run/mysqld/mysqld.pid
fi

if [ -e /var/lib/mysql/mysql.sock ]
then
	rm -f /var/lib/mysql/mysql.sock
fi


rm -f /var/run/httpd/*
rm -f /tmp/*
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

service httpd start
service mysqld start
