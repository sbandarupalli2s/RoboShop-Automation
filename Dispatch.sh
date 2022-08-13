source Common.sh

Golang_install
AddUsr

echo "Downloading the code for dispatch"
curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip &>>/tmp/dispatch.log
status_check

echo "deleting the old content"
rm -rf catalogue
status_check

rm -rf catalogue
echo "unzipping the file"
unzip -o /tmp/dispatch.zip && cd /home/roboshop && mv dispatch-main dispatch && cd dispatch &>>/tmp/catalogue.log
status_check

#cd /home/roboshop
#mv dispatch-main dispatch && cd dispatch

echo "init"
go mod init dispatch
go get
go build

mv /home/roboshop/dispatch/systemd.service /etc/systemd/system/dispatch.service
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch