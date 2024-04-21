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

$tf_vars_path = "$PSScriptRoot\kubernetes.tfvars"
$tfvar_exists = Test-Path $tf_vars_path
if ( $tfvar_exists -eq $False )
{
    Copy-Item -Path $PSScriptRoot\template.tfvars -Destination $tf_vars_path
}

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\container-registry
terragrunt init
terragrunt apply -lock=false -var do_token=$do_token $auto_approve $non_interactive -var-file $tf_vars_path
docker login -u $do_token -p $do_token registry.digitalocean.com
Pop-Location

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\kubernetes-cluster
terragrunt init
terragrunt apply -lock=false -var do_token=$do_token $auto_approve $non_interactive -var-file $tf_vars_path
Pop-Location

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\kubernetes
terragrunt init
terragrunt apply -lock=false -var do_token=$do_token $auto_approve $non_interactive
Pop-Location