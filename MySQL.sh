
COMPONENT=mysql

source Common.sh

if [ -z "$MYSQL_PASSWORD" ]; then
  echo -e "\e[33m env variable MYSQL_PASSWORD is missing \e[0m"
  exit 1
fi

echo "setting nodejs repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>/tmp/mysql.log
status_check

echo "Installing mysql "
yum install mysql-community-server -y &>>/tmp/mysql.log
status_check

echo "starting the mysql..."
systemctl enable mysqld && systemctl start mysqld &>>/tmp/mysql.log
status_check

echo "grep the default password "
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo $DEFAULT_PASSWORD

echo $MYSQL_PASSWORD

echo "alter user 'root'@'localhost' identified with mysql_native_password by '$MYSQL_PASSWORD';" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD}

mysql -uroot -p$MYSQL_PASSWORD
status_check

#>uninstall plugin validate_password;
echo "Downloading the  mysql.zip file "
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>/tmp/mysql.log
status_check


cd /tmp
echo "unzipping the file"
unzip -o mysql.zip &>>/tmp/mysql.log
status_check

cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql