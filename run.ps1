param(
    [string] $cmd = "apply",
    [bool] $ap = $False
)

$do_token = Get-Content .\access-token.txt -Raw
Push-Location -Path .\digitalocean\SFO3\kubernetes\

IF ($cmd -eq "ap")
{
    $cmd = "apply"
}
IF ($cmd -eq "dt")
{
    $cmd = "destroy"
}

$auto_approve = ""
if ( $ap -eq $True )
{
    $auto_approve = "-auto-approve"
}

# Write $cmd
# Write $auto_approve
terragrunt $cmd -lock=false -var do_token=$do_token $auto_approve

Pop-Location