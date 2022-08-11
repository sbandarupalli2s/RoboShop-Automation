source Common.sh

echo "setting nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/cart.log
status_check

echo "Installing NodeJS"
yum install nodejs -y &>>/tmp/cart.log
status_check

echo "Checking user exists or not"
id roboshop &>>/tmp/cart.log
if [ $? -eq 0 ]; then
  echo "user already exists"
  status_check
else
  echo adding user
  useradd roboshop &>>/tmp/cart.log
  status_check
fi

echo "Downloading application content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" && cd /home/roboshop &>>/tmp/cart.log
status_check

echo "Deleting the old application content"
rm -rf cart &>>/tmp/cart.log
status_check

echo "Unzipping"
unzip -o /tmp/cart.zip &>>/tmp/cart.log && mv cart-main cart && cd cart &>>/tmp/cart.log
status_check

echo "installing NodeJS dependencies"
npm install &>>/tmp/cart.log
status_check

echo "configuring cart systemd service "
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log
systemctl daemon-reload &>>/tmp/cart.log
status_check

echo "starting service"
systemctl start cart && systemctl enable cart &>>/tmp/cart.log
status_check