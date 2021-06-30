# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
  end
  config.vm.define "nasnfs" do |nasnfs|
    nasnfs.vm.hostname = "nasnfs"
    nasnfs.vm.provision :shell, path: "nasnfs.sh"
    nasnfs.vm.network "private_network", ip: "10.0.3.2"
  end
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.provision :shell, path: "master.sh"
    master.vm.network "private_network", ip: "10.0.3.3"
  end
  config.vm.define "node1" do |node1|
    node1.vm.hostname = "node1"
    node1.vm.provision :shell, path: "worker.sh"
    node1.vm.network "private_network", ip: "10.0.3.4"
  end
  config.vm.define "node2" do |node2|
    node2.vm.hostname = "node2"
    node2.vm.provision :shell, path: "worker.sh"
    node2.vm.network "private_network", ip: "10.0.3.5"
  end
end
