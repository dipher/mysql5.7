#!/bin/bash

if ( test -e "/tmp/mysql-5.7.33-linux-glibc2.12-x86_64.tar" ); then
    echo "The File exists,/tmp/mysql-5.7.33-linux-glibc2.12-x86_64.tar"
else
    wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.33-linux-glibc2.12-x86_64.tar -O /tmp/mysql-5.7.33-linux-glibc2.12-x86_64.tar
fi

if ( test -e "/tmp/mysql-5.7.33-linux-glibc2.12-x86_64.tar.gz" ); then
    echo "The File exists,/tmp/mysql-5.7.33-linux-glibc2.12-x86_64.tar.gz"
else
    tar xvf /tmp/mysql-5.7.33-linux-glibc2.12-x86_64.tar -C /tmp/
fi

exit 0
 
