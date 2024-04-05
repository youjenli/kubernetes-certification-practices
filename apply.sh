#!/bin/bash

if [[ !"$#" -gt 0 ]]; then
  AUTO_APPROVE=""
fi

case $1 in
    -aa|--auto-approve) 
      if [ $2 == "true" ]; then
        AUTO_APPROVE="--auto-approve"
      fi
esac
# echo $AUTO_APPROVE

SCRIPT_PATH=`realpath $(dirname -- "${BASH_SOURCE[0]}")`
# echo "$SCRIPT_PATH"

DO_TOKEN="$(<"$SCRIPT_PATH/access-token.txt")"
#https://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell

export REMOTE_BACKEND_BUCKET="$(<"$SCRIPT_PATH/remote_backend.txt")"

if [ ! -f $SCRIPT_PATH/kubernetes.tfvars ]; then
  cp $SCRIPT_PATH/template.tfvars $SCRIPT_PATH/kubernetes.tfvars
fi

cd $SCRIPT_PATH/digitalocean/SFO3/kubernetes/
terragrunt init
terragrunt apply -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE -var-file $SCRIPT_PATH/kubernetes.tfvars
docker login -u $DO_TOKEN -p $DO_TOKEN registry.digitalocean.com
cd -