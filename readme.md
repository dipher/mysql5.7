Install mysql-5.7.32-linux-glibc2.12-x86_64.tar.gz   
  安装二进制版本mysql-5.7.32   

1 Download the install files   
  下载安装文件
cd /opt/   
git clone https://git@github.com/dipher/mysql5.7.git   
sh mysql-download-files.sh   

2 Install...   
  开始安装   
  mysql_basedir=/usr/local/mysql   
  backup the old directory (/usr/local/mysql) to /usr/local/mysql.XXX.bk   
sh mysql-install.sh   

3 Modify the port in the file(mysql-init.sh).    
  if use multiple instances, after modifying to a different port, run the script   
sh mysql-init.sh   

4 Start as service    
systemctl start mysql${port}    
 
