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

.\init.ps1

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\container-registry
terragrunt init
terragrunt apply -lock=false -var do_token=$Env:do_token $auto_approve $non_interactive -var-file $tf_vars_path
docker login -u $Env:do_token -p $Env:do_token registry.digitalocean.com
Pop-Location

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\kubernetes-cluster
terragrunt init
terragrunt apply -lock=false -var do_token=$Env:do_token $auto_approve $non_interactive -var-file $tf_vars_path
Pop-Location

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\kubernetes
terragrunt init
terragrunt apply -lock=false -var do_token=$Env:do_token $auto_approve $non_interactive
Pop-Location