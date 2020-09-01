#!/bin/bash
q1="CREATE USER 'lambda-user'@'%' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS'"
q2="GRANT all  ON iamtest.* TO 'lambda-user'@'%';"

r1=$(echo $q1 | mysql -v -h$1 -u$2 -p$3 2>&1)
r2=$(echo $q2 | mysql -v -h$1 -u$2 -p$3 2>&1)

echo '{"r1":"$r1", "r2":"$r2"}'
exit 0
