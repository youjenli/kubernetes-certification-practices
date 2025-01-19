kubectl create -f .\haddock.yml  --kubeconfig ..\..\..\..\.kubeconfig
kubectl create -f .\haddock-quota.yml  --kubeconfig ..\..\..\..\.kubeconfig
kubectl create -f .\nosql.yml --namespace haddock  --kubeconfig ..\..\..\..\.kubeconfig