#!/usr/bin/env bash

# Imports:
source $(dirname $0)/vars

printf "Installation Kubernetes: master ..."
# Init master:
kubeadm init --apiserver-advertise-address $kubeip --apiserver-bind-port $kubeport --pod-network-cidr=10.244.0.0/16
kubeadm token create --print-join-command >> /vagrant/join_kube_cluster

# Configuration de l'utilisateur:
cp /etc/kubernetes/admin.conf /root/
echo "export KUBECONFIG=$HOME/admin.conf" >> /root/.bashrc

# Installation du pod réseau:
export KUBECONFIG=$HOME/admin.conf
kubectl apply -f $kub_flannel_url

# Check:
kubectl get nodes
