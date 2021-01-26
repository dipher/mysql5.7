#!/bin/bash

base_dir=/usr/local/mysql

mysql_port=3306
mysql_ip=0.0.0.0
mysql_basedir=/opt/mysql/mysql${mysql_port}

if (ss -ant | grep ":${mysql_port}"); then 
   echo the port:${mysql_port} already in used, exit. 
   exit 0
fi

if [ -d "${mysql_basedir}" ]; then
    mv ${mysql_basedir} ${mysql_basedir}.$(date +%Y%m%d%H%M%S).bk
fi

mkdir -p ${mysql_basedir}/{etc,data,arch,log,tmp}

# create user mysql
useradd -r -s /bin/false mysql

> ${mysql_basedir}/log/mysql.log

chown -R mysql:mysql /usr/local/mysql
chmod -R 750 /usr/local/mysql
chown -R mysql:mysql ${mysql_basedir}
chmod -R 750 ${mysql_basedir}

cp -rf my.cnf  ${mysql_basedir}/etc/

sed -i s#/opt/mysql/mysql3306#${mysql_basedir}#g ${mysql_basedir}/etc/my.cnf
sed -i s#3306#${mysql_port}#g ${mysql_basedir}/etc/my.cnf
sed -i s#0.0.0.0#${mysql_ip}#g ${mysql_basedir}/etc/my.cnf

mysql_service=${mysql_basedir}/mysql${mysql_port}
cp -f ${base_dir}/support-files/mysql.server ${mysql_service}

sed -i 46i\mysql_mdir=${mysql_basedir} ${mysql_service}
sed -i 45,50s#basedir=#basedir=/usr/local/mysql# ${mysql_service}
sed -i 45,50s#datadir=#datadir=\${mysql_mdir}/data# ${mysql_service}
sed -i 61,65s#mysqld_pid_file_path=#mysqld_pid_file_path=\${mysql_mdir}/data/mysql.pid# ${mysql_service}
sed -i 265,270s#datadir=\"\$datadir\"#defaults-file="\${mysql_mdir}/etc/my.cnf"# ${mysql_service}

cp -f ${mysql_service} /etc/rc.d/init.d/mysql${mysql_port}
cp -f ${mysql_service} ${mysql_basedir}/mysql.server

echo
echo 1 Initialize database
echo database initializing ...
${base_dir}/bin/mysqld --defaults-file=${mysql_basedir}/etc/my.cnf --log-error=${mysql_basedir}/log/mysql.log --user=mysql --initialize 
${base_dir}/bin/mysql_ssl_rsa_setup --datadir=${mysql_basedir}/data/
echo

echo 2 Look for the default password for root
echo The temporary password for root , look for ${mysql_basedir}/log/mysql.log
cat ${mysql_basedir}/log/mysql.log | grep 'temporary password'
echo

echo 3 Run mysql server
#/usr/local/mysql/bin/mysqld_safe --defaults-file=${mysql_basedir}/etc/my.cnf --user=mysql &
echo Mysql server is starting ...
${mysql_basedir}/mysql.server start
echo

echo 4 Login mysql server and modify the password of root
echo "
 1 login mysql
 /usr/local/mysql/bin/mysql -S ${mysql_basedir}/data/mysql.sock -p

 2 modify the pwd
 set password for 'root'@'%' = password('newpwd')
 
 3 auto start
 chkconfig mysql${mysql_port} on
 service mysql${mysql_port} start
END.
"
 
