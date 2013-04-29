#!/bin/bash

IP=$(hostname -I)
IPMASK=$(ip a | grep $IP | awk '{print $2}')
MASK=$(ipcalc $IPMASK | awk '/Netmask/ {print $2}')
GATEWAY=$(route -n | awk '/UG/ {print $2}')

#remove old dhcp entries
sed -i  '9,10d' /target/etc/network/interfaces

cat >> /target/etc/network/interfaces <<EOF
iface eth0 inet static
        address $IP
        netmask $MASK
        gateway $GATEWAY
EOF

ip a >> ip_fix.out
route -n >> ip_fix.out
echo $IP >> ip_fix.out
echo $IPMASK >> ip_fix.out
echo $MASK >> ip_fix.out
echo $GATEWAY >> ip_fix.out
