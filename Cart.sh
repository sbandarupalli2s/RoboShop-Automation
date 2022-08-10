
echo "setting nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/cart.log
if [ $? == 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mSUCCESS\e[0m"
fi

echo "Installing NodeJS"
yum install nodejs -y &>>/tmp/cart.log
echo $?

echo "Adding user"
useradd roboshop &>>/tmp/cart.log
echo $?

echo "Downloading application content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>/tmp/cart.log
echo $?

cd /home/roboshop &>>/tmp/cart.log
echo "Deleting the old application content"
rm -rf cart &>>/tmp/cart.log
echo $?

echo "Unzipping"
unzip -o /tmp/cart.zip &>>/tmp/cart.log
echo $?

mv cart-main cart &>>/tmp/cart.log
cd cart

echo "installing NodeJS dependencies"
npm install &>>/tmp/cart.log
echo $?

echo "configuring cart systemd service "
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log
systemctl daemon-reload &>>/tmp/cart.log
echo $?

echo "starting service"
systemctl start cart &>>/tmp/cart.log
echo $?
systemctl enable cart &>>/tmp/cart.log