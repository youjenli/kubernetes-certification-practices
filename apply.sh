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

source ./init.sh

cd $SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/container-registry
terragrunt init
terragrunt apply -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE -var-file $TF_VARS_PATH
export REGISTRY_ENDPOINT=$(terragrunt output -raw registry_endpoint)
cd -

docker login -u $DO_TOKEN -p $DO_TOKEN registry.digitalocean.com
alias dk="docker"

cd $SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/kubernetes-cluster
terragrunt init
terragrunt apply -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE -var-file $TF_VARS_PATH
cd -

# Alias
current=$(pwd)
alias kbl="kubectl --kubeconfig $current/.kubeconfig"

cd $SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/kubernetes
terragrunt init
terragrunt apply -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE
cd -