#!/bin/bash
## Disable the firewall
sudo ufw disable
##
sudo apt-get update
sudo apt-get install -y vim curl wget net-tools git
## Installing Ansible
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/Ansible
sudo apt install -y ansible
## Set hostname for VM 
hostname jumphost
##
