#!/bin/bash

export INIT_SCRIPT_PATH=`realpath $(dirname -- "${BASH_SOURCE[0]}")`
# echo "$SCRIPT_PATH"

# Load REMOTE_BACKEND_BUCKET to environment variable, so that it could be retrieved and passed to Terraform.
export DO_TOKEN="$(<"$INIT_SCRIPT_PATH/access-token.txt")"
#https://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell

export REMOTE_BACKEND_BUCKET="$(<"$INIT_SCRIPT_PATH/remote_backend.txt")"

TF_VARS_PATH="$INIT_SCRIPT_PATH/kubernetes.tfvars"
if [ ! -f $TF_VARS_PATH ]; then
  cp $INIT_SCRIPT_PATH/template.tfvars $TF_VARS_PATH
fi