kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#Check if all pods are ready
kubectl get pods --all-namespaces

#Create discovery.yaml
kubectl -n kube-public get configmap cluster-info -o jsonpath='{.data.kubeconfig}' > discovery.yaml

## Copy the discovery.yaml to each workers, replace <user> with real user,replace 10.IP.ADD.RESS with real IP
# scp  