source  Common.sh

echo "Downloading the mongodb repo."
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>/tmp/mongodb.log
status_check

echo "Installing the mongodb."
yum install -y mongodb-org &>>/tmp/mongodb.log
status_check

echo "starting the mongodb..."
systemctl enable mongod && systemctl start mongod &>>/tmp/mongodb.log
status_check

#Need to update the IP address

echo "restarting the mongodb..."
systemctl restart mongod &>>/tmp/mongodb.log
status_check

echo "downloading the Schema to be loaded for the application to work."
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>/tmp/mongodb.log
status_check

cd /tmp
status_check

echo "unzipping the file"
unzip mongodb.zip &>>/tmp/mongodb.log
status_check

cd mongodb-main
#mongo < catalogue.js
#mongo < users.js

echo "Done"
