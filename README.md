# Install mysql-5.7.32-linux-glibc2.12-x86_64.tar.gz
# 安装二进制版本mysql-5.7.32

#1 download the install files
#1 下载安装文件
cd /opt/
sh mysql-download-files.sh

#2 install...
#2 开始安装
# mysql_basedir=/usr/local/mysql
# backup the old directory (/usr/local/mysql) to /usr/local/mysql.XXX.bk

sh mysql-install.sh

#3 modify the port in the file(mysql-init.sh). if use multiple instances, after modifying to a different port, run the script

sh mysql-init.sh

#4 start as service
systemctl start mysql${port} 
