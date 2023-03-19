#!/bin/bash

sed -i 's/^.* ssh-rsa /ssh-rsa /' /root/.ssh/authorized_keys
sed -i 's/PermitRootLogin forced-commands-only/PermitRootLogin yes/' /etc/ssh/sshd_config
service ssh restartq

inst_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo inst_id $inst_id
echo -n $inst_id > /var/local/inst_id

yum install -y httpd

cat <<EOF > /var/www/html/index.html
$inst_id from tpl</br>
str_name: ${str_name}</br>
the list:</br><ul>
%{ for x in list_names~}
</li>elem: ${x}
%{ endfor ~}
</ul>

EOF

systemctl start httpd.service
