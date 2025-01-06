#!/bin/bash

export ALIAS_SCRIPT_PATH=`realpath $(dirname -- "${BASH_SOURCE[0]}")`

source $ALIAS_SCRIPT_PATH/init.sh

docker login -u $DO_TOKEN -p $DO_TOKEN registry.digitalocean.com
alias dk="docker"

alias kbl="kubectl --kubeconfig $INIT_SCRIPT_PATH/.kubeconfig"

alias hlm="helm --kubeconfig $INIT_SCRIPT_PATH/.kubeconfig"