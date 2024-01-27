param(
    [bool] $aa = $False
)

$auto_approve = ""
if ( $aa -eq $True )
{
    $auto_approve = "-auto-approve"
}

$do_token = Get-Content .\access-token.txt -Raw

Push-Location -Path .\digitalocean\SFO3\kubernetes\
terragrunt init
terragrunt destroy -lock=false -var do_token=$do_token $auto_approve
docker logout registry.digitalocean.com
Pop-Location