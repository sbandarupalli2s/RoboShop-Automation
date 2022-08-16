# This Script is to keep the code DRY by using functions.

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
}


App_Clean() {
  echo "Deleting the old application content"
  rm -rf ${COMPONENT} &>>/tmp/${COMPONENT}.log
  status_check

  echo "Unzipping/Extract Application Archive"
  unzip -o /tmp/${COMPONENT}.zip &>>/tmp/${COMPONENT}.log
  mv ${COMPONENT}-main ${COMPONENT} && cd ${COMPONENT} &>>/tmp/${COMPONENT}.log
  status_check
}

Download() {
  echo "Downloading ${COMPONENT} content"
  curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" && cd /home/roboshop &>>/tmp/${COMPONENT}.log
  status_check
}


AddUsr() {
  echo "Checking user exists or not"
  id roboshop &>>/tmp/cart.log
  if [ $? -eq 0 ]; then
    echo "user already exists"
    status_check
  else
    echo adding user
    useradd roboshop &>>/tmp/addusr.log
    status_check
  fi
}


SYSTEMD() {
  echo Update SystemD Config
  sed -i -e 's/MONGO_DNSNAME/mongodb-dev.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb-dev.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis-dev.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue-dev.roboshop.internal/' -e 's/AMQPHOST/rabbitmq-dev.roboshop.internal/' -e 's/CARTHOST/cart-dev.roboshop.internal/' -e 's/USERHOST/user-dev.roboshop.internal/' -e 's/CARTENDPOINT/cart-dev.roboshop.internal/' -e 's/DBHOST/mysql-dev.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${COMPONENT}.log
  status_check

  echo Configuring ${COMPONENT} SystemD Service
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG} && systemctl daemon-reload &>>${COMPONENT}.log
  status_check

  echo Starting ${COMPONENT} Service
  systemctl restart ${COMPONENT} &>>${COMPONENT}.log && systemctl enable ${COMPONENT} &>>${COMPONENT}.log
  status_check
}

##### this is what i refer from my classes.

NodeJS_install() {
  echo "Setting nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/nodejs.log
  status_check

  echo "Installing NodeJS"
  yum install nodejs -y &>>/tmp/nodejs.log
  status_check

  AddUsr
  Download
  App_Clean

  echo "installing NodeJS dependencies"
  npm install &>>/tmp/${COMPONENT}.log
  status_check

  SYSTEMD
}


Nginx_install() {
  echo "Installing nginx..."
  yum install nginx -y &>>/tmp/nginx_installation.log
  status_check

  echo " starting nginx..."
  systemctl enable nginx && systemctl start nginx &>>/tmp/nginx_installation.log
  status_check
}

Golang_install() {
  echo "installing golang...."
  yum install golang -y &>>/tmp/golang.log
  status_check
}