#!/usr/bin/env bash

set -xeuo pipefail

# Install EPEL and enable CRB
dnf -y install 'dnf-command(config-manager)' epel-release
dnf config-manager --set-enabled crb
dnf -y upgrade epel-release

# Install packages
dnf -y install --setopt=install_weak_deps=False \
    cifs-utils \
    container-tools \
    distrobox \
    git-core \
    lshw \
    make \
    system-reinstall-bootc \
    systemd-container \
    time \
    tree \
    usbutils \
    wget \
    btop \
    fastfetch \
    fzf \
    gum \
    just \
    nvtop \
    podman-compose \
    steam-devices

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
