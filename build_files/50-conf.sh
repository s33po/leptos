#!/usr/bin/env bash

set -xeuo pipefail

# Add user.just to image
install -Dm644 /ctx/build_files/user.just /usr/share/just/user.just

# Create global alias for user.just commands
echo "alias jmain='just --justfile /usr/share/just/user.just'" > /etc/profile.d/jmain.sh
chmod 644 /etc/profile.d/jmain.sh

# Use breezedark by default
#sed -i 's|^LookAndFeelPackage=.*|LookAndFeelPackage=org.kde.breezedark.desktop|' \
#  /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

#sed -i 's|^ColorScheme=.*|ColorScheme=BreezeDark|' \
#  /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

# Write firewalld zone "Workstation" (more permissive than stock)
mkdir -p /usr/lib/firewalld/zones
cat > /usr/lib/firewalld/zones/Workstation.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>Workstation</short>
  <description>Unsolicited incoming network packets are rejected from port 1 to 1024,
except for select network services. Incoming packets that are related to
outgoing network connections are accepted. Outgoing network connections are
allowed.</description>
  <service name="dhcpv6-client"/>
  <service name="samba-client"/>
  <port protocol="udp" port="1025-65535"/>
  <port protocol="tcp" port="1025-65535"/>
  <forward/>
</zone>
EOF

# Set default firewalld zone to "Workstation"
firewall-offline-cmd --set-default-zone=Workstation
