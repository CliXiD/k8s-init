#Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

helm repo add stable https://kubernetes-charts.storage.googleapis.com/

#Install nfs client provisioner
helm install nfs-client stable/nfs-client-provisioner --set nfs.server=192.168.50.101 --set nfs.path=/k8snfs/erp/

#Install nginx-ingress
#Edit nginx-values.yaml in section externalIPs for real IP(s) which going to expose
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress -f nginx-values.yaml