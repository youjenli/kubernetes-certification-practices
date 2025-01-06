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
terragrunt apply -lock=false -var do_token=$Env:do_token $auto_approve $non_interactive -var-file $Env:tf_vars_path
$exit_code = $?
if ( $exit_code -eq $True)
{
    docker login -u $Env:do_token -p $Env:do_token registry.digitalocean.com
}
Pop-Location
if ( $exit_code -ne $True )
{
    exit $exit_code
}

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\kubernetes-cluster
terragrunt init
terragrunt apply -lock=false -var do_token=$Env:do_token $auto_approve $non_interactive -var-file $Env:tf_vars_path
$exit_code = $?
Pop-Location
if ( $exit_code -ne $True )
{
    exit $exit_code
}

Push-Location -Path $PSScriptRoot\terragrunt\digitalocean\SFO3\kubernetes-certification\kubernetes
terragrunt init
terragrunt apply -lock=false -var do_token=$Env:do_token $auto_approve $non_interactive
$exit_code = $?
Pop-Location
if ( $exit_code -ne $True )
{
    exit $exit_code
}