
set -e

echo "setting nodejs repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>/tmp/mysql.log

echo "Installing mysql "
yum install mysql-community-server -y &>>/tmp/mysql.log

systemctl enable mysqld
systemctl start mysqld

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo "alter user 'root'@'localhost' identified with mysql_native_password by 'new_password' " | mysql -uroot -p$(DEFAULT_PASSWORD)

mysql -uroot -pRoboShop@1

#>uninstall plugin validate_password; &>>/tmp/mysql.log

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>/tmp/mysql.log

cd /tmp &>>/tmp/mysql.log
unzip mysql.zip &>>/tmp/mysql.log
cd mysql-main &>>/tmp/mysql.log
mysql -u root -pRoboShop@1 <shipping.sql &>>/tmp/mysql.log