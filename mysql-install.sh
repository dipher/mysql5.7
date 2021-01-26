#!/bin/bash

# download all the nstall file to the current directory

install_file=mysql-5.7.32-linux-glibc2.12-x86_64.tar.gz
install_file_dir=`echo ${install_file} | awk -F".tar" '{print $1}'`
mysql_basedir=/opt/mysql/mysql3306

# ready for some file
 

if [ ! -d "/usr/local/${install_file_dir}" ]; then
    tar -zxf ${install_file} -C /usr/local/
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
cp -f my.cnf ${mysql_basedir}/etc/
cp -f mysql-init.sh /usr/local/mysql/

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


