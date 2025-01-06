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

DESTROY_SCRIPT_PATH=`realpath $(dirname -- "${BASH_SOURCE[0]}")`
# echo "$DESTROY_SCRIPT_PATH"

source $DESTROY_SCRIPT_PATH/init.sh

cd  $INIT_SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/kubernetes
terragrunt init
terragrunt destroy -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE -refresh=false 
# Add -refresh=false to make kubernetes module access remote k8s resources instead of local resources.
# https://github.com/hashicorp/terraform-provider-kubernetes/issues/1028
cd -

cd  $INIT_SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/kubernetes-cluster
terragrunt init
terragrunt destroy -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE
cd -

cd  $INIT_SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/container-registry
terragrunt init
terragrunt destroy -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE $NONE_INTERACTIVE
docker logout registry.digitalocean.com
cd -