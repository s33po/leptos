#!/usr/bin/env bash
set -xeuo pipefail

SCRIPT_DIR="$(dirname "$0")"

# Set quiet bootc updates
sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' \
    /usr/lib/systemd/system/bootc-fetch-apply-updates.service

# Set update interval and ensure the timer persist across reboots
sed -i \
    -e 's|^OnUnitInactiveSec=.*|OnUnitInactiveSec=3d|' \
    -e '/^#\?Persistent=/{s||Persistent=true|;b}' \
    -e '$aPersistent=true' \
    /usr/lib/systemd/system/bootc-fetch-apply-updates.timer

# Set automatic update policy to 'stage'
sed -i 's|^#\?AutomaticUpdatePolicy=.*|AutomaticUpdatePolicy=stage|' \
    /etc/rpm-ostreed.conf

# Add Flathub remote and default flatpak list
mkdir -p /etc/flatpak/remotes.d
curl --retry 3 -o /etc/flatpak/remotes.d/flathub.flatpakrepo "https://dl.flathub.org/repo/flathub.flatpakrepo"
install -Dm644 "${SCRIPT_DIR}/defpaks.list" /etc/flatpak/defpaks.list

# Add user.just to image
install -Dm644 "${SCRIPT_DIR}/user.just" /usr/share/just/user.just

# Create global alias for user.just commands
echo "alias jmain='just --justfile /usr/share/just/user.just'" > /etc/profile.d/jmain.sh
chmod 644 /etc/profile.d/jmain.sh

# Set default target to graphical
systemctl set-default graphical.target

# Enable services
systemctl enable bootc-fetch-apply-updates.timer
systemctl enable plasmalogin.service
systemctl enable podman.socket
systemctl enable tuned.service

# Disable services
systemctl disable rpm-ostree-countme.timer