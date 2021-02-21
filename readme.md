# Install mysql-5.7.33-linux-glibc2.12-x86_64.tar.gz   
#  安装二进制版本mysql-5.7.33   

#1 Downloading the install files   
#  下载安装文件   
   cd /opt/   
   git clone https://git@github.com/dipher/mysql5.7.git    
   cd mysql5.7   

#2 Installing...   
#  开始安装   
#  mysql_basedir=/usr/local/mysql   
#  backup the old directory (/usr/local/mysql) to /usr/local/mysql.XXX.bk   
   sh mysql-install.sh   

#3 Initializing MySQL Server
   sh mysql-init.sh 3306 /data/mysql/3306
#  Usage: sh mysql-init.sh mysql_port mysql_data_dir   
 
 
