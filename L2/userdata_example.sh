#!/bin/bash

sed -i 's/^.* ssh-rsa /ssh-rsa /' /root/.ssh/authorized_keys
sed -i 's/PermitRootLogin forced-commands-only/PermitRootLogin yes/' /etc/ssh/sshd_config
service ssh restartq

inst_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo inst_id $inst_id
echo -n $inst_id > /var/local/inst_id

yum install -y httpd
echo $inst_id > /var/www/html/index.html

systemctl start httpd.service
