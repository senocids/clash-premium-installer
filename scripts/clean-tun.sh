#!/bin/bash

. /etc/default/clash

ip route del default dev utun table "$IPROUTE2_TABLE_ID"
ip rule del fwmark "$NETFILTER_MARK" lookup "$IPROUTE2_TABLE_ID"

nft -f - << EOF
flush table clash
delete table clash
EOF

# in /etc/sysctl.conf, modify following value to 0:
# net.ipv4.ip_forward, net.ipv6.conf.all.forwarding
# or, uncomment the following lines
# sysctl -w net/ipv4/ip_forward=0
# sysctl -w net/ipv6/conf/all/forwarding=0

exit 0
