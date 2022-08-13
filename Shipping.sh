source Common.sh

echo installing the maven
yum install maven -y &>>/tmp/shipping.log
status_check

AddUsr

cd /home/roboshop
echo downloading the shipping code.
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip" &>>/tmp/shipping.log
status_check

rm -rf shipping

echo unzipping..
unzip -o /tmp/shipping.zip &>>/tmp/shipping.log
status_check

mv shipping-main shipping
cd shipping

echo cleaning the maven packages.
mvn clean package &>>/tmp/shipping.log
status_check

mv target/shipping-1.0.jar shipping.jar
mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
echo "daemon-reloading..."
systemctl daemon-reload &>>/tmp/shipping.log
status_check

echo "starting the shipping service."
systemctl start shipping && systemctl enable shipping &>>/tmp/shipping.log
status_check