#!/bin/bash
## Disable the firewall
sudo ufw disable
##
add-apt-repository -y cloud-archive:epoxy
##
sudo dpkg --configure -a
apt-get update
apt-get install -y vim curl wget net-tools 
##
## Set hostname for VM 
hostname compute-node-01
##
## Configure name resolution
echo "10.0.1.11   controller-node-01" >> /etc/hosts
echo "10.0.1.31   compute-node-01" >> /etc/hosts
##
## Install and configure Chrony
apt-get install chrony
## echo "allow 10.0.0.0/16" >> /etc/chrony/chrony.conf
systemctl enable chrony
systemctl restart chrony
##
## Install the Nova service
apt-get install -y nova-compute
