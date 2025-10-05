#!/bin/bash
## Disable the firewall
sudo ufw disable
##
sudo apt-get update
sudo apt-get install -y vim curl wget net-tools git haproxy
## Installing Ansible
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/Ansible
sudo apt-get install -y ansible
## Set hostname for VM 
hostname jumphost
##
##
echo "# Example basic configuration" >> /etc/haproxy/haproxy.cfg
echo "frontend http_front" >> /etc/haproxy/haproxy.cfg
echo "    bind *:80" >> /etc/haproxy/haproxy.cfg
echo "    default_backend web_servers" >> /etc/haproxy/haproxy.cfg
echo "backend web_servers" >> /etc/haproxy/haproxy.cfg
echo "    balance roundrobin" >> /etc/haproxy/haproxy.cfg
echo "    server web1 10.0.1.11:5000 check" >> /etc/haproxy/haproxy.cfg
##
## Install colorls
sudo apt-get -y install ruby libgmp-dev gcc make ruby-dev ruby-colorize
sudo gem install colorls
echo "alias ls='colorls -A --group-directories-first --gs'" | sudo tee -a /root/.bashrc
if [ "`ls /home/ | grep ubuntu`" != "" ] 
then 
  echo "alias ls='colorls -A --group-directories-first --gs'" | sudo tee -a /home/ubuntu/.bashrc
fi


