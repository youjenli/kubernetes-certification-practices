param(
    [string] $cmd = "apply",
    [bool] $aa = $False
)

function Docker-Login ([string]$do_token)
{
    docker login -u $do_token -p $do_token registry.digitalocean.com
}

function Docker-Logout
{
    docker logout registry.digitalocean.com
}

$docker_handler = $null
$do_token = Get-Content .\access-token.txt -Raw
Push-Location -Path .\digitalocean\SFO3\kubernetes\

IF ($cmd -eq "ap")
{
    $cmd = "apply"
    $docker_handler = "Docker-Login"
}
IF ($cmd -eq "dt")
{
    $cmd = "destroy"
    $docker_handler = "Docker-Logout"
}

$auto_approve = ""
if ( $aa -eq $True )
{
    $auto_approve = "-auto-approve"
}

terragrunt init
terragrunt $cmd -lock=false -var do_token=$do_token $auto_approve

Pop-Location

& $docker_handler $do_token