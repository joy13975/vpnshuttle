#!/bin/bash -e

host_ip=$(./scripts/run/get_host_ip.sh)
echo "
PasswordAuthentication yes
PermitRootLogin yes
PermitTunnel yes

AllowUsers appuser@${host_ip}" > /etc/ssh/sshd_config