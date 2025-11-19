# Getting Started

## Requirements

## 1. Install the OpenStack environment
Below you can find an example of the vaults.yml file. This file should be created manually in the root of the Ansible directory. 
```
      'CmQYmDbmuYcW'
##
## Placement variables
##
placement_mariadb_password:     '27DvUKgXTdSA'
placement_identity_password:    'c9E7QZXyh8Yb'
##
## Nova variables
##
nova_mariadb_password:          'shdaMM8E7pxf'
nova_rabbit_password:           'Pj2VH45Aw4SS'
nova_identity_password:         '27DvUKgXTdSA'
##
## Nova variables
##
neutron_mariadb_password:       'KM6CYkTtrUeX'
neutron_rabbit_password:        'AGdNyWFw7ubM'
neutron_identity_password:      'xRgYvJSZs8jE'
neutron_metadata_proxy_secret:  '2GMhVmC83fY5'
##
## Heat variables
##
heat_mariadb_password:          'Nhumwqt9Vrqs'
heat_rabbit_password:           'mzE5zfWbE6kP'
heat_identity_password:         'P4VH3PeQjDkr'
heat_domain_identity_password:  'Gv72gUhtrZhf'
##
## Zun variables
##
zun_mariadb_---
##
## The OpenStack environment
##
## Global variables
##
project_name:         'kpi'
user_domain_name:     'Default'
project_domain_name:  'Default'
proxy_server:         '44.192.88.16'
##
admin_project_name:   'admin'
admin_username:       'admin'
##
##
## Keystone variables
##
keystone_bootstrap_password:    'Qwerty1234'
keystone_mariadb_password:      'wP38sd4D3CWZ'
keystone_rabbit_password:       '3HtKPWwMXyvs'
##
## Skyline variables
##
skyline_mariadb_password:       'zE94EwB3USjk'
skyline_rabbit_password:        'ERbVDvhKpM64'
skyline_identity_password:      'XBS9qvregbeQ'
##
## Horizon variables
##
## Glance variables
##
glance_mariadb_password:        'arhzgTgGUG57'
glance_rabbit_password:         'ykZ8cczSfxNh'
glance_identity_password: password:           'AYCbJe2MSb4B'
zun_rabbit_password:            'cBuwNNd8VekD'
zun_identity_password:          'ZZZGCS7hHcQt'
##
## Magnum variables
##
magnum_mariadb_password:        'zepVmP73WbCC'
magnum_rabbit_password:         'h4KTXsbVeEC5'
magnum_identity_password:       'CXVzvZUB77tG'
magnum_domain_identity_password:  '9WjwkMeBe5Pm'
##
## Magnum variables
##
cinder_mariadb_password:        'P3XTgLzavVaB'
cinder_rabbit_password:         'nP8pJkDJFNX2'
cinder_identity_password:       'D5ZZz2gqRWH6'
##
```
