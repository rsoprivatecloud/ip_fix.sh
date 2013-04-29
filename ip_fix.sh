#!/bin/bash

IP=$(hostname -I)
IPMASK=$(ip a | grep $IP | awk '{print $2}')
MASK=$(ipcalc $IPMASK | awk '/Netmask/ {print $2}')
GATEWAY=$(route -n | awk '/UG/ {print $2}')

#remove old dhcp entries
sed -i  '9,10d' /target/etc/network/interfaces

cat >> /etc/network/interfaces <<EOF
iface eth0 inet static
        address $IP
        netmask $MASK
        gateway $GATEWAY
EOF

/etc/init.d/networking restart
ifup eth0
