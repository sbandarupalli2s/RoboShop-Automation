#The frontend is the service in RobotShop to serve the web content over Nginx.
source Common.sh

echo "Installing nginx..."
yum install nginx -y &>>/tmp/frontend.log
status_check

echo " starting nginx..."
systemctl enable nginx && systemctl start nginx &>>/tmp/frontend.log
status_check

echo "collecting the data..."
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend.log

cd /usr/share/nginx/html
rm -rf *

echo "unzipping..."
unzip /tmp/frontend.zip &>>/tmp/frontend.log
mv frontend-main/static/* . && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo "restarting nginx.."
systemctl restart nginx &>>/tmp/frontend.log
