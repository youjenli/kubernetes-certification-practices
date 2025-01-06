param(
    [bool] $aa = $False
)

$auto_approve = ""
$non_interactive = ""
if ( $aa -eq $True )
{
    $auto_approve = "-auto-approve"
    $non_interactive = "--terragrunt-non-interactive"
}

$do_token = Get-Content $PSScriptRoot\access-token.txt -Raw

$Env:REMOTE_BACKEND_BUCKET = Get-Content $PSScriptRoot\remote_backend.txt -Raw

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\kubernetes
terragrunt init
terragrunt destroy -lock=false -var do_token=$do_token $auto_approve $non_interactive -refresh=false
# Add -refresh=false to make kubernetes module access remote k8s resources instead of local resources.
# https://github.com/hashicorp/terraform-provider-kubernetes/issues/1028
Pop-Location

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\kubernetes-cluster
terragrunt init
terragrunt destroy -lock=false -var do_token=$do_token $auto_approve $non_interactive
Pop-Location

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\container-registry
terragrunt init
terragrunt destroy -lock=false -var do_token=$do_token $auto_approve $non_interactive
docker logout registry.digitalocean.com
Pop-Location