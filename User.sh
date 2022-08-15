COMPONENT=user

source Common.sh

NodeJS_install
AddUsr

echo "Downloading application USER content"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>/tmp/user.log
status_check

cd /home/roboshop

echo "Deleting the old application content"
rm -rf user &>>/tmp/user.log
status_check

echo "unzipping the content"
unzip -o /tmp/user.zip &>>/tmp/user.log
status_check

mv user-main user
cd /home/roboshop/user

echo "installing dependencies"
npm install &>>/tmp/user.log
status_check

echo "configuring cart systemd service"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload &>>/tmp/user.log
status_check

echo "starting USER service"
systemctl start user && systemctl enable user &>>/tmp/user.log
status_check
