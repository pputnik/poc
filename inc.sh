# functions used in shell scripts

log (){
  echo $(date "+%b %d %H:%M:%S") $name$DOMAIN $1
}

exi(){  # report before exit to "apply-all.sh" that we're done
  #echo $name > ./tmp/$name
  exit $1
}

deploy_stack() {
steps=$((tom*12))  # we'll check status every 5 secs
to="--timeout-in-minutes $tom"

#========= stack deployment ======================
log "checking if $stackname exists: "
status=$(aws cloudformation describe-stacks $stackname 2>&1| grep 'StackStatus"' | awk -F'"' '{print $4}')
if [ "$status" == "ROLLBACK_IN_PROGRESS" ] || [ "$status" == "DELETE_IN_PROGRESS" ] || [ "$status" == "UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS" ] ; then
        x=20
        log "$status, waiting for end"
        while [ $x -gt 0 ]; do
            statusn=$(aws cloudformation describe-stacks $stackname 2>&1| grep 'StackStatus"' | awk -F'"' '{print $4}')
                if [ "$statusn" == "$status" ]; then
                  x=$((x-1))
                  log "$x $statusn...."
                  sleep 2
                else x=0
                fi
        done
fi
if [ "$statusn" == "$status" ] && [ "x$status" != "x" ]; then  # still incomplete, failing
  return 1
fi

if [ "$status" == "ROLLBACK_FAILED" ] || [ "$status" == "ROLLBACK_COMPLETE" ] || [ "$status" == "CREATE_FAILED" ] || [ "$status" == "DELETE_FAILED" ] || [ "$status" == "UPDATE_ROLLBACK_FAILED" ]; then
        log " $status, try to delete"
        aws cloudformation delete-stack $stackname
        x=20
        while [ $x -gt 0 ]; do
                status=$(aws cloudformation describe-stacks $stackname 2>&1 | grep 'StackStatus"' | awk -F'"' '{print $4}')
                log "$status"
                if [ "x$status" == "x" ]; then
                        x=0
                        log "creating...."
                        aws cloudformation create-stack $stackname $to $templatebody $tags $capab $params
                fi
                x=$((x-1))
                sleep 2
        done
elif [ "$status" == "CREATE_COMPLETE" ] || [ "$status" == "UPDATE_ROLLBACK_COMPLETE" ] || [ "$status" == "UPDATE_COMPLETE" ]  || [ "$status" == "ROLLBACK_COMPLETE" ] ; then
        log "exist, ($status). Starting update: "
        set +e
        update_out=$(aws cloudformation update-stack $stackname $templatebody $tags $capab $params 2>&1)
        set -e

        #                    there is an error             and
        if [ "$(echo $update_out | grep error -c)" != "0" ] && \
            #    the error isn't "nothing to do"
           [ "$(echo $update_out | grep 'No updates are to be performed' -c)" = "0"  ]; then
          echo "ERR during update-stack $stackname"
          echo "$update_out"
          exit 1
        fi
else
        log " not exist: $status"
        log "creating ...."
        aws cloudformation create-stack $stackname $to $templatebody $tags $capab $params
fi

#===============================
 # waiting until CF finishes its work.
while [ $steps -gt 0 ]; do
  status=$(aws cloudformation describe-stacks $stackname 2>&1| grep 'StackStatus"' | awk -F'"' '{print $4}')
  log "$steps $status"
  if [ "$status" == "ROLLBACK_FAILED" ] || [ "$status" == "ROLLBACK_COMPLETE" ] || [ "$status" == "CREATE_FAILED" ] || [ "$status" == "DELETE_FAILED" ] || [ "$status" == "ROLLBACK_IN_PROGRESS" ] || [ "$status" == "DELETE_IN_PROGRESS" ] || [ "$status" == "UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS" ] || [ "$status" == "UPDATE_ROLLBACK_COMPLETE" ] || [ "$status" == "UPDATE_ROLLBACK_FAILED" ]  || [ "$status" == "UPDATE_ROLLBACK_IN_PROGRESS" ] ; then
    echo "$status"
    return 1
  elif [ "$status" == "CREATE_COMPLETE" ] || [ "$status" == "UPDATE_COMPLETE" ] ; then
    echo "success"
    steps=0
  else
    steps=$((steps-1))
    sleep 5
  fi
done

} # deploy_stack function end

update_ssm(){
  param_name=$1
  new_val=$2
  if [ "x$param_name" = "x" ] || [ "x$new_val" = "x" ] ; then
    echo "ERR: update_ssm needs two parameters, got: param_name='$param_name', new_val='$new_val'"
    exi 1
  fi
  is_secure=$3
  if [ "x$is_secure" = "x" ]; then  # just string
    type="--type String"
    wd=""
  else
    type="--type SecureString"
    wd="--with-decryption"
  fi
  echo -n "$type "

  if [ "x$REGION" != "x" ]; then
    my_reg="--region $REGION"
  fi
  params="--query Parameter.Value --output text"
  # get old values
  old_val=$(aws ssm get-parameter --name "$param_name" "$wd" $my_reg $params || echo "")
  if [ "$old_val" = "$new_val" ]; then
    echo "$param_name already ok"
    return
  fi

  # update it
  aws ssm put-parameter --name "$param_name" $type --value "$new_val" --overwrite $my_reg | jq -c
}

get_ssm(){
  param_name=$1
  if [ "x$param_name" = "x" ] ; then
    echo "ERR: get_ssm requires param name"
    exi 1
  #else
  #  ( echo "get_ssm: param_name=$param_name" >&2 )
  fi
  is_secure=$2
  if [ "x$is_secure" = "x" ]; then  # just string
    wd=""
  else
    wd="--with-decryption"
  fi

  if [ "x$REGION" != "x" ]; then
    my_reg="--region $REGION"
  fi
  params="--query Parameter.Value --output text"
  # get old values
  val=$(aws ssm get-parameter --name "$param_name" "$wd" $my_reg $params || echo "")

  echo "$val"
  # ( echo "get_ssm: val=$val" >&2 )

}
