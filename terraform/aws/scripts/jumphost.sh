#!/bin/bash
## Disable the firewall
sudo ufw disable
##
sudo apt-get update
sudo apt-get install -y vim curl wget net-tools git
## Installing Ansible
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/Ansible
sudo apt-get install -y ansible
## Set hostname for VM 
hostname jumphost
##
## Install colorls
sudo apt-get -y install ruby libgmp-dev gcc make ruby-dev ruby-colorize
sudo gem install colorls
echo "alias ls='colorls -A --group-directories-first --gs'" | sudo tee -a /root/.bashrc
if [ "`ls /home/ | grep ubuntu`" != "" ] 
then 
  echo "alias ls='colorls -A --group-directories-first --gs'" | sudo tee -a /home/ubuntu/.bashrc
fi
