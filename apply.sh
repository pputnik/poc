#!/bin/bash -ex

#awsume
GIT_SUBMODULE_STRATEGY="recursive"
#git submodule sync --recursive
#git submodule update --init --recursive

# TF_LOG=DEBUG terraform init
export TF_IN_AUTOMATION=true

terraform init
terraform workspace select alex || terraform workspace new alex
terraform validate

# 'ni' for plan only, 'nig' (ni+go) for apply too
if [ "x$1" == "xni" -o "x$1" == "xnig" ] ; then
        noinvoke="-var creation=\"\""
fi

bucket="-var use_existing_bucket=acl-logs-alex"
firstTarget="-target module.update_user_pool.module.policy"
terraform plan -input=false $bucket $noinvoke # $firstTarget

if [ "x$1" != "x" -a "x$1" != "xni" ] ; then
        terraform apply -auto-approve -input=false $bucket $noinvoke #$firstTarget


        #terraform plan -input=false $bucket    # makes no sense to run this plan until firstTarget applied

        #terraform apply -auto-approve -input=false $bucket
fi