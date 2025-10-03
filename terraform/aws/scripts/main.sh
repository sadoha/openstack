#!/bin/bash
## Disable the firewall
sudo ufw disable
##
sudo apt-get update
sudo apt-get install -y vim curl wget net-tools 
## Set hostname for VM 
