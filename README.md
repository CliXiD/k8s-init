# k8s-init
Create K8S cluster on CentOS

1 Install and configure system

- 00-master.sh run on master node
- 00-worker.sh run on each worker nodes

2 Install network controller (flannel) and prepare the discovery file

- 01-manual-master.sh run on master node, recommend to execute manually

 - check all pods are ready before next one
 - check comments in script for copy the discovery file to each worker nodes

3 Join with all workers
- 02-manual-worker.sh run on each worker nodes

4 Install helm, nfs-client, and nginx-ingress controller
- 03-manual-master.sh
