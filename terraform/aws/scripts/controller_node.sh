#!/bin/bash
## Disable the firewall
ufw disable
##
add-apt-repository -y cloud-archive:epoxy
##
sudo dpkg --configure -a
apt-get update
apt-get install -y vim curl wget net-tools 
##
## Set hostname for VM 
hostname controller-node-01
##
## Configure name resolution
echo "10.0.1.11   controller-node-01" >> /etc/hosts
echo "10.0.1.31   compute-node-01" >> /etc/hosts
##
## Install and configure Chrony
apt-get install chrony
echo "allow 10.0.0.0/16" >> /etc/chrony/chrony.conf
systemctl enable chrony
systemctl restart chrony
##
## Install the openstack client is the CLI for openstack operations
apt-get install -y python3-openstackclient
##
## SQL database for Ubuntu
## https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html#install-and-configure-components
## Install the packages
apt-get install -y mariadb-server python3-pymysql
## Create and edit the openstack.cnf file and complete the following actions
touch /etc/mysql/mariadb.conf.d/99-openstack.cnf
cat <<EOF > /etc/mysql/mariadb.conf.d/99-openstack.cnf
[mysqld]
bind-address = 10.0.1.11
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF
## Restart the database service
systemctl enable mariadb
systemctl restart mariadb
## Secure the database service by running the mysql_secure_installation script
## mysql_secure_installation
##
## Message queue for Ubuntu
## Install the packages
apt-get install -y rabbitmq-server 
## Add the openstack user
## Replace RABBIT_PASS with a suitable password
rabbitmqctl add_user openstack RABBIT_PASS
## Permit configuration, write, and read access for the openstack add_user
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
##
## Memcached for Ubuntu 
## Install the packages
apt-get install -y memcached python3-memcache
## Enable access by other nodes via the management network
sed -i 's/-l 127.0.0.1/-l 10.0.1.11/g' /etc/memcached.conf
## Restart the Memcached service
systemctl enable memcached
systemctl restart memcached
##
## Etcd for Ubuntu 
## Install the packages
apt-get install -y etcd-server
## Enable access by other nodes via the management network
cat <<EOF > /etc/default/etcd
ETCD_NAME="controller"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER="controller=http://10.0.1.11:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.0.1.11:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://10.0.1.11:2379"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://10.0.1.11:2379"
EOF
## Enable and restart the etcd service
systemctl enable etcd
systemctl restart etcd
