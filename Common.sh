status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
}

NodeJS() {
  echo "setting nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/nodejs.log
  status_check

  echo "Installing NodeJS"
  yum install nodejs -y &>>/tmp/nodejs.log
  status_check
}

AddUsr() {
  echo "Checking user exists or not"
  id roboshop &>>/tmp/cart.log
  if [ $? -eq 0 ]; then
    echo "user already exists"
    status_check
  else
    echo adding user
    useradd roboshop &>>/tmp/addusr.log
    status_check
  fi
}