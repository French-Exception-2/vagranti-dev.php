#!/usr/bin/env bash

sudo /sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1

content=$(cat <<EOF
# désactivation de ipv6 pour toutes les interfaces
net.ipv6.conf.all.disable_ipv6 = 1

# désactivation de l’auto configuration pour toutes les interfaces
net.ipv6.conf.all.autoconf = 0

# désactivation de ipv6 pour les nouvelles interfaces (ex:si ajout de carte réseau)
net.ipv6.conf.default.disable_ipv6 = 1

# désactivation de l’auto configuration pour les nouvelles interfaces
net.ipv6.conf.default.autoconf = 0
EOF
)

echo "$content" | sudo tee -a /etc/sysctl.conf

sudo sysctl -p
