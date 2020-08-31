#!/bin/bash

echo "CREATE USER 'lambda-user'@'%' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS';"

echo "GRANT all  ON iamtest.* TO 'lambda-user'@'%';"