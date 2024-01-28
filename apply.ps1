param(
    [bool] $aa = $False
)

$auto_approve = ""
if ( $aa -eq $True )
{
    $auto_approve = "-auto-approve"
}

$do_token = Get-Content $PSScriptRoot\access-token.txt -Raw

$tfvar_exists = Test-Path $PSScriptRoot\kubernetes.tfvars
if ( $tfvar_exists -eq $False )
{
    Copy-Item -Path $PSScriptRoot\template.tfvars -Destination $PSScriptRoot\kubernetes.tfvars
}

Push-Location -Path $PSScriptRoot\digitalocean\SFO3\kubernetes\
terragrunt init
terragrunt apply -lock=false -var do_token=$do_token $auto_approve -var-file $PSScriptRoot\kubernetes.tfvars
docker login -u $do_token -p $do_token registry.digitalocean.com
Pop-Location