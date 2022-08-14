source Common.sh

echo " Installing the python3..."
yum install python36 gcc python3-devel -y &>>/tmp/payment.log
status_check

AddUsr

cd /home/roboshop

echo "Downloading the payment source code..."
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip" &>>/tmp/payment.log
status_check

cd /home/roboshop
rm -rf payment

echo "unzipping the payment.zip file"
unzip -o /tmp/payment.zip
status_check

mv payment-main payment

cd /home/roboshop/payment

echo "Installing pip3..."
pip3 install -r requirements.txt &>>/tmp/payment.log
status_check

echo "Moving the systemd file to /etc/systemd/system/"
mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
status_check

echo "daemon-reloading..."
systemctl daemon-reload &>>/tmp/payment.log
status_check

echo "stating the payment service.."
systemctl enable payment && systemctl start payment &>>/tmp/payment.log
status_check
