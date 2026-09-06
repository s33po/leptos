#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"

# Set quiet bootc updates
sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' \
    /usr/lib/systemd/system/bootc-fetch-apply-updates.service

# Set update interval and ensure the timer persists across reboots
sed -i \
    -e '/^#\?Persistent=/d' \
    -e 's|^OnUnitInactiveSec=.*|OnUnitInactiveSec=3d\nPersistent=true|' \
    /usr/lib/systemd/system/bootc-fetch-apply-updates.timer

# Add Flathub remote and default flatpak list
mkdir -p /etc/flatpak/remotes.d
curl -fsSL --retry 3 --retry-all-errors -o /etc/flatpak/remotes.d/flathub.flatpakrepo "https://dl.flathub.org/repo/flathub.flatpakrepo"
install -Dm644 "${SCRIPT_DIR}/defpaks.list" /etc/flatpak/defpaks.list

# Add user.just to image
install -Dm644 "${SCRIPT_DIR}/user.just" /usr/share/just/user.just

# Create global alias for user.just commands
echo "alias jmain='just --justfile /usr/share/just/user.just'" > /etc/profile.d/jmain.sh
chmod 644 /etc/profile.d/jmain.sh

# Firewalld configuration for discovery services
firewall-offline-cmd --add-service=mdns
firewall-offline-cmd --add-service=ws-discovery

# Set default target to graphical
systemctl set-default graphical.target

# Enable services
systemctl enable bootc-fetch-apply-updates.timer
systemctl enable firewalld
systemctl enable plasmalogin.service
systemctl enable podman.socket
systemctl enable tuned.service

# Disable services
systemctl disable rpm-ostree-countme.timer
