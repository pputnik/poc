#!/bin/bash
#-vx

profile="--profile sandbox"

BRANCH=$(git status | grep "On branch" | sed "s/On branch //")
git reset --hard "origin/$BRANCH"
git pull --no-edit
aws sts $profile get-caller-identity

echo -n testing prep
templatebody="--template-body file://spinnaker.yml"
aws cloudformation $profile validate-template $templatebody >/dev/null
if [ $? -ne 0 ]; then
        echo " syntax error"
        exit 1
fi

name="spinnaker"
tags="--tags Key=Name,Value=$name Key=Responsible,Value=Alex"
stackname="$profile --stack-name $name"
# capab="--capabilities CAPABILITY_IAM"
capab="--capabilities CAPABILITY_NAMED_IAM"
# --parameters ParameterKey=VPCID,ParameterValue=SampleVPCID ParameterKey=SubnetIDs,ParameterValue=SampleSubnetID1\\,SampleSubnetID2
params="--parameters file://spinnaker.params"

#===============================
echo
echo -n "checking if exists "
status=$(aws cloudformation describe-stacks $stackname 2>&1| grep 'StackStatus"' | awk -F'"' '{print $4}')
if [ "$status" == "ROLLBACK_FAILED" ] || [ "$status" == "ROLLBACK_COMPLETE" ] || [ "$status" == "CREATE_FAILED" ] || [ "$status" == "DELETE_FAILED" ] || [ "$status" == "ROLLBACK_IN_PROGRESS" ] || [ "$status" == "DELETE_IN_PROGRESS" ] || [ "$status" == "UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS" ] ; then
        echo " $status, try to delete"
        aws cloudformation delete-stack $stackname
        x=20
        while [ $x -gt 0 ]; do
                status=$(aws cloudformation describe-stacks $stackname 2>&1 | grep 'StackStatus"' | awk -F'"' '{print $4}')
                echo "$status"
                if [ "x$status" == "x" ]; then
                        x=0
                        echo creating....
                        aws cloudformation create-stack $stackname --timeout-in-minutes 210 $templatebody $tags $capab $params
                        aws cloudformation wait $stackname
                fi
                x=$(($x-1))
                sleep 2
        done
elif [ "$status" == "CREATE_COMPLETE" ] || [ "$status" == "UPDATE_ROLLBACK_COMPLETE" ] || [ "$status" == "UPDATE_COMPLETE" ] || [ "$status" == "UPDATE_ROLLBACK_FAILED" ] ; then
        echo "exist, ($status). Starting update: "
        aws cloudformation update-stack $stackname $templatebody $tags $capab $params
        aws cloudformation wait $stackname

else
        echo " not exist: $status"

        echo creating ....
        aws cloudformation create-stack $stackname --timeout-in-minutes 210 $templatebody $tags $capab $params
        aws cloudformation wait $stackname
fi

echo end
