#!/bin/bash

#kubeadm worker on CentOS 7

# Housekeeping
yum update -y
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
echo "Housekeeping done"

#Install Docker
yum install -y yum-utils device-mapper-persistent-data lvm2 yum-plugin-versionlock
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-19.03.8 docker-ce-cli-19.03.8 containerd.io-1.2.13
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl enable docker
groupadd docker
MAINUSER=$(logname)
usermod -aG docker $MAINUSER
systemctl start docker
yum versionlock docker-ce docker-ce-cli containerd.io
echo "Docker Installation done"

#Install K8s Stuff
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet kubeadm kubectl
echo "Kube Stuff done"
systemctl enable --now kubelet
systemctl start kubelet
yum versionlock kubelet kubeadm kubectl
echo "Kubelet started done"

#Network Stuff
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system
yum install nfs-utils -y
echo "Network Stuff done"

#Kubeadm config
tee /etc/kubernetes/kubeadminitworker.yaml >/dev/null <<EOF
apiVersion: kubeadm.k8s.io/v1beta1
discovery:
  file:
    kubeConfigPath: discovery.yaml
  timeout: 5m0s
  tlsBootstrapToken: y7yaev.9dvwxx6ny4ef8vlq
kind: JoinConfiguration
EOF
echo "Kubeadm config ready"