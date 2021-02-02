This set will deploy Spryker B2C demo to your AWS account.
Only one environment for one country (EU :) ) will be deployed, all in the same region, with the minimal resource usage by default.
The instance will be publicly-accessible.

## Requirements: 
* CLI access to create Cloudformation stack
* access to DNS to configure the domain you want to use

## Deployment:
1. `git clone`
2. `vim spryker.params`, change is ***!! REQUIRED !!*** for:
    1. `key`, otherwise you won't be able to log ni to your EC2
    2. `BaseDomain`: e.g. `shop.com`, stack will use its subdomains (see below)
    3. `Responsible`: your last name here 
    4. `VpcId`: the VPC you want to deploy to
    5. `DefRouteId`: default route in that VPC

    Also, you might want to edit CIDRs and Ec2Ami (must be Ubuntu 18 in your region, the given AMI ID is valid for Frankfurt)

3. Go to [ParameterStore](https://console.aws.amazon.com/systems-manager/parameters/?tab=Table), double-check region and create parameters as below. Due to CF limitations, only the version 1 will be used.
    * /Spryker/htpasswd/EU/user (the only `String` here, NOT `SecureString`)
    * /Spryker/htpasswd/EU/pass
    * /Spryker/Rds/pass
    * /Spryker/rabbit/adm_pass
    * /Spryker/rabbit/spryker_pass
4. `./apply.sh`
5. After the stack is deployed, get the IP of the only EC2 instance and create the following subdomains:
    * glue.shop.com
    * yves 
    * zed
    * jenkins
    