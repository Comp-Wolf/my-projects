#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
yum install git -y
#TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXX"
cd /home/ec2-user && git clone https://raw.githubusercontent.com/Comp-Wolf/my-projects/main/DevOps/terraform/Project-002-Terraform-Phonebook-Application-deployed-on-AWS/phonebook-app.py