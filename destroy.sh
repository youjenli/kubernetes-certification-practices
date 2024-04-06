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
echo "$SCRIPT_PATH"

DO_TOKEN="$(<"$SCRIPT_PATH/access-token.txt")"
#https://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell

export REMOTE_BACKEND_BUCKET="$(<"$SCRIPT_PATH/remote_backend.txt")"

cd  $SCRIPT_PATH/terragrunt/digitalocean/SFO3/kubernetes-certification/
terragrunt init
terragrunt destroy -lock=false -var do_token=$DO_TOKEN $AUTO_APPROVE -refresh=false
# Add -refresh=false to make kubernetes module access remote k8s resources instead of local resources.
# https://github.com/hashicorp/terraform-provider-kubernetes/issues/1028
docker logout registry.digitalocean.com
cd -