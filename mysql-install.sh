#!/bin/bash

# download install file to /tmp/ , such as mysql-5.7.32-linux-glibc2.12-x86_64.tar.gz and my.cnf
download_server="http://10.32.238.30/mysql"
install_file=mysql-5.7.32-linux-glibc2.12-x86_64.tar.gz
install_file_dir=`echo ${install_file} | awk -F".tar" '{print $1}'`
mysql_basedir=/opt/mysql/mysql3306

# ready for some file
 
wget ${download_server}/cfg/my.cnf -O /tmp/my.cnf
wget ${download_server}/cfg/mysql-init.sh -O /tmp/mysql-init.sh

if [ ! -d "/usr/local/${install_file_dir}" ]; then
    wget ${download_server}/${install_file} -O /tmp/${install_file}
    tar -zxf /tmp/${install_file} -C /usr/local/
fi

if [ ! -d "/usr/local/mysql" ]; then
    cp -r /usr/local/${install_file_dir} /usr/local/mysql
else
    echo  Notice: the directory /usr/local/mysql exists, will backup it.
    mv /usr/local/mysql /usr/local/bk.mysql$(date +%Y%m%d%H%M%S)
    cp -r /usr/local/${install_file_dir} /usr/local/mysql
fi

if ( cat /etc/profile | grep "/usr/local/mysql/bin"); then
    echo $PATH
else
    echo "PATH=/usr/local/mysql/bin:$PATH" >> /etc/profile
    echo $PATH
fi

# create directory

if [ -d "${mysql_basedir}" ]; then
    echo Notice: the directory ${mysql_basedir} exists, will backup it.
    mv ${mysql_basedir} ${mysql_basedir}.$(date +%Y%m%d%H%M%S).bk
fi

mkdir -p ${mysql_basedir}/{etc,data,arch,log,tmp}
cp -f /tmp/my.cnf  		${mysql_basedir}/etc/
cp -f /tmp/mysql-init.sh  	/usr/local/mysql/

# create user mysql
useradd -r -s /bin/false mysql

#
> ${mysql_basedir}/log/mysql.log

chown -R mysql:mysql /usr/local/mysql
chmod -R 755 /usr/local/mysql
chown -R mysql:mysql ${mysql_basedir}
chmod -R 750 ${mysql_basedir}

#
yum -y install libaio

# ready for my.cnf

sed -i "s#/opt/mysql/mysql3306#${mysql_basedir}#g" ${mysql_basedir}/etc/my.cnf

echo "Please read /usr/local/mysql/mysql-init.sh"


