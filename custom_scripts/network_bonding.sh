#!/bin/bash

cat << 'EOF' > /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback
 
auto eth0
iface eth0 inet manual
  bond-master bond0
 
auto eth1
iface eth1 inet manual
  pre-up sleep 4
  bond-master bond0
 
auto bond0
iface bond0 inet static
    address 192.168.112.11
    netmask 255.255.255.192
    bond-slaves eth0 eth1
    bond-mode 1
 
 
post-up route add -net 192.168.0.0/16 gw 192.168.112.1
post-up route add -net 192.168.112.0/20 gw 192.168.112.1
post-up route add -net 172.16.0.0/16 gw 192.168.112.1
 
auto bond1
iface bond1 inet manual
  bond-slaves none
  bond-mode 802.3ad
  bond-miimon 100
  bond-downdelay 200
  bond-updelay 200
  bond-xmit-hash-policy 1
  bond-ad-select 1
  bond-lacp-rate 1
 
auto eth2
iface eth2 inet manual
bond-master bond1
 
auto eth3
iface eth3 inet manual
pre-up sleep 4
bond-master bond1
 
auto bond1.2002
iface bond1.2002 inet static
  address 135.110.216.11
  gateway 135.110.216.1
  netmask 255.255.255.128
  vlan-raw-device bond1
  dns-nameservers 135.207.177.11 135.207.164.11
 
auto bond1.2001
iface bond1.2001 inet static
  address 192.168.128.11
  netmask 255.255.240.0
  vlan-raw-device bond1
EOF
