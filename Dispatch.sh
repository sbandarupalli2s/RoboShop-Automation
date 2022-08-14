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
unzip -o /tmp/dispatch.zip && cd /home/roboshop && mv dispatch-main dispatch && cd dispatch &>>/tmp/dispatch.log
status_check

#cd /home/roboshop
#mv dispatch-main dispatch && cd dispatch

echo "init"
go mod init dispatch
go get
go build

echo " moving the systemd file to /etc/systemd/system/"
mv /home/roboshop/dispatch/systemd.service /etc/systemd/system/dispatch.service
status_check

echo "daemon-reloading.."
systemctl daemon-reload &>>/tmp/dispatch.log
status_check

echo "stating the dispatch service "
systemctl enable dispatch && systemctl start dispatch &>>/tmp/dispatch.log
status_check
