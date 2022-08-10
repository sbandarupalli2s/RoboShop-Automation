
set -e

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>/tmp/mysql.log

yum install mysql-community-server -y &>>/tmp/mysql.log

systemctl enable mysqld &>>/tmp/mysql.log
systemctl start mysqld &>>/tmp/mysql.log

grep temp /var/log/mysqld.log &>>/tmp/mysql.log

mysql_secure_installation &>>/tmp/mysql.log

mysql -uroot -pRoboShop@1 &>>/tmp/mysql.log

uninstall plugin validate_password; &>>/tmp/mysql.log

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>/tmp/mysql.log

cd /tmp &>>/tmp/mysql.log
unzip mysql.zip &>>/tmp/mysql.log
cd mysql-main &>>/tmp/mysql.log
mysql -u root -pRoboShop@1 <shipping.sql &>>/tmp/mysql.log