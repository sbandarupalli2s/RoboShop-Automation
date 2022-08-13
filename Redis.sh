source Common.sh

echo "Downloading the source code..."
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>/tmp/redis.log
status_check

echo "Installing the redis... "
yum install redis-6.2.7 -y &>>/tmp/redis.log
status_check

echo "starting redis..."
systemctl enable redis && systemctl start redis &>>/tmp/redis.log
status_check
