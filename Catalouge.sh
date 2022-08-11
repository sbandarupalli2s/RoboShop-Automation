source Common.sh

NodeJS_install
AddUsr

#sudo su roboshop

echo "Downloading the code for catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>/tmp/catalogue.log
status_check

cd /home/roboshop
rm -rf catalogue
unzip /tmp/catalogue.zip &>>/tmp/catalogue.log
status_check

mv catalogue-main catalogue && cd /home/roboshop/catalogue

echo "installing dependencies "
npm install &>>/tmp/catalogue.log
status_check

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service

echo "starting catalogue "
systemctl daemon-reload &>>/tmp/catalogue.log
systemctl start catalogue && systemctl enable catalogue &>>/tmp/catalogue.log
status_check

