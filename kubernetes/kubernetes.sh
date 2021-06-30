#!/usr/bin/env bash
# Installation des outils Kubernetes.

# Options:
#    $1 : master

# Imports:
source $(dirname $0)/vars

# Input:
if [[ -n $1 ]] && [[ $1 != 'master' ]]; then
    echo "Param error."
    exit 1
fi

# Configuration du partage NFS:
echo "$nasip nasserver" | tee -a /etc/hosts

# Installation d'outil pour le déploiement:
apt-get update -y
apt-get install rpl

# Desactivation du swap:
swapoff -a

# Activation du routage:
echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf

# Installation des prerequis:
apt-get update -y
apt-get install -y \
        wget \
        curl \
        gnupg2 \
        apt-transport-https \
        ca-certificates \
        gpgv \
        software-properties-common \
        nfs-kernel-server

# Installation de Docker:
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
echo "deb https://download.docker.com/linux/debian stretch stable" | tee -a /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce

# Modification du demarrage de Docker pour kubertnetes:
exec_line=$(grep ExecStart= /lib/systemd/system/docker.service)
exec_new="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --exec-opt native.cgroupdriver=systemd"
rpl -i -w "$exec_line" "$exec_new" /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker.service

# Mise en place du depot de paquets de Kubernetes:
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

# Installation des paquets de kubernetes:
apt-get update -y
apt-get install -y kubeadm kubelet

# Activation du service kubelet:
systemctl enable kubelet

if [[ $1 == 'master' ]]; then
   apt-get install kubectl
fi
