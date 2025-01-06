# Load do_token to environment variables for later use.
$Env:do_token = Get-Content $PSScriptRoot\access-token.txt -Raw
# https://stackoverflow.com/questions/36023694/pass-a-variable-to-another-script

# Load REMOTE_BACKEND_BUCKET to environment variable, so that it could be retrieved and passed to Terraform.
$Env:REMOTE_BACKEND_BUCKET = Get-Content $PSScriptRoot\remote_backend.txt -Raw

$Env:tf_vars_path = "$PSScriptRoot\kubernetes.tfvars"
$tfvar_exists = Test-Path $Env:tf_vars_path
if ( $tfvar_exists -eq $False )
{
    Copy-Item -Path $PSScriptRoot\template.tfvars -Destination $Env:tf_vars_path
}
