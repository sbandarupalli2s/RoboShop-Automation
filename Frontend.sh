#The frontend is the service in RobotShop to serve the web content over Nginx.

yum install nginx -y
systemctl enable nginx
systemctl start nginx

curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx

echo "Completed"