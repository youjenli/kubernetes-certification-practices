# Add these alias to your powershell profile before setting up kubernetes.

New-Alias -Name dk -Value docker

# Set kubernetes alias
function Invoke-Kubectl {
    kubectl --kubeconfig $Env:KubeconfigRoot\.kubeconfig $Args
}

# https://stackoverflow.com/questions/4166370/how-can-i-write-a-powershell-alias-with-arguments-in-the-middle
New-Alias -Name kbl -Value Invoke-Kubectl