#!/usr/bin/env bash

# Variables:
network=10.0.3.0/24

# Installer NFS:
apt-get update -y
apt-get install -y nfs-kernel-server

# Creation du répertoire:
mkdir -p /share/nfs/myapi
chmod -R 755 /share/nfs/myapi
cp /vagrant/data.txt /share/nfs/myapi
chown -R nobody:nogroup /share/nfs/myapi

# Init NFS:
echo "/share/nfs/myapi $network(rw,sync,no_subtree_check)" | tee -a /etc/exports
exportfs -a
/etc/init.d/nfs-kernel-server start
