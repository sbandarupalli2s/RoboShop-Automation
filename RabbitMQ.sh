source Common.sh

echo "Downloading the rabbitmq."
sudo yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/rabbitmq.log
status_check

echo curl .....
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
status_check

echo "Installing the rabbitmq..."
yum install rabbitmq-server -y &>>/tmp/rabbitmq.log
status_check

echo "starting the rabbitmq"
systemctl enable rabbitmq-server && systemctl start rabbitmq-server &>>/tmp/rabbitmq.log
status_check

echo "adding the rabbitmqctl user roboshop "
rabbitmqctl add_user roboshop roboshop123
status_check

echo "setting the user tags.."
rabbitmqctl set_user_tags roboshop administrator
status_check

secho "setting the permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
status_check