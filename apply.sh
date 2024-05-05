#!/bin/bash

if [[ !"$#" -gt 0 ]]; then
  AUTO_APPROVE=""
  NONE_INTERACTIVE=""
fi

case $1 in
    -aa|--auto-approve)
      if [ $2 == "true" ]; then
        AUTO_APPROVE="--auto-approve"
        NONE_INTERACTIVE="--terragrunt-non-interactive"
      fi
esac
# echo $AUTO_APPROVE

export APPLY_SCRIPT_PATH=`realpath $(dirname -- "${BASH_SOURCE[0]}")`

source $APPLY_SCRIPT_PATH/init.sh

cd $INIT_SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/container-registry
terragrunt init
terragrunt apply -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE -var-file $TF_VARS_PATH
export REGISTRY_ENDPOINT=$(terragrunt output -raw registry_endpoint)
cd -

cd $INIT_SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/kubernetes-cluster
terragrunt init
terragrunt apply -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE -var-file $TF_VARS_PATH
cd -

cd $INIT_SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/kubernetes
terragrunt init
terragrunt apply -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE
cd -