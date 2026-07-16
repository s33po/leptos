#!/usr/bin/env bash

set -xeuo pipefail

# Install EPEL and enable CRB
dnf -y install 'dnf-command(config-manager)'
dnf config-manager --set-enabled crb
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm

# Set global dnf options
dnf config-manager --save \
    --setopt=max_parallel_downloads=10

# Install packages
dnf -y install --setopt=install_weak_deps=False \
    cifs-utils \
    container-tools \
    podman-compose \
    distrobox \
    firewalld \
    fuse \
    git-core \
    lshw \
    qemu-guest-agent \
    rsync \
    system-reinstall-bootc \
    systemd-container \
    systemd-resolved \
    tuned-ppd \
    usbutils \
    nvme-cli \
    lsof \
    bind-utils \
    nano \
    openssl \
    xfsdump \
    ncurses \
    wget

# Preset and enable resolved
tee /usr/lib/systemd/system-preset/91-resolved-default.preset > /dev/null <<'EOF'
enable systemd-resolved.service
EOF

tee /usr/lib/tmpfiles.d/resolved-default.conf > /dev/null <<'EOF'
L /etc/resolv.conf - - - - ../run/systemd/resolve/stub-resolv.conf
EOF

systemctl preset systemd-resolved.service

# Set quiet bootc updates
sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/bootc update --quiet|' \
    /usr/lib/systemd/system/bootc-fetch-apply-updates.service

# Set update interval and ensure the timer persist across reboots
sed -i \
    -e 's|^OnUnitInactiveSec=.*|OnUnitInactiveSec=3d|' \
    -e 's|^#\?Persistent=.*|Persistent=true|' \
    /usr/lib/systemd/system/bootc-fetch-apply-updates.timer

# Set automatic update policy to 'stage'
sed -i 's|^#\?AutomaticUpdatePolicy=.*|AutomaticUpdatePolicy=stage|' \
    /etc/rpm-ostreed.conf
