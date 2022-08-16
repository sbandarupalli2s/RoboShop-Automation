COMPONENT=rabbitmq

source Common.sh
if [ -z "$APP_RABBITMQ_PASSWORD" ]; then
  echo -e "\e[33m env variable APP_RABBITMQ_PASSWORD is needed\e[0m"
  exit 1
fi


echo "Setup YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/rabbitmq.log
status_check

echo "Installing the rabbitmq..."
yum install rabbitmq-server -y &>>/tmp/rabbitmq.log
status_check

echo "starting the rabbitmq"
systemctl enable rabbitmq-server && systemctl start rabbitmq-server &>>/tmp/rabbitmq.log
status_check

rabbitmqctl list_users | grep roboshop  &>>/tmp/rabbitmq.log
if [ $? -ne 0 ]; then
  echo Add App User in RabbitMQ
  rabbitmqctl add_user roboshop ${APP_RABBITMQ_PASSWORD} &>>/tmp/rabbitmq.log && rabbitmqctl set_user_tags roboshop administrator &>>/tmp/rabbitmq.log && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/rabbitmq.log
  status_check
fi