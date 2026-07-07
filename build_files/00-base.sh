#!/usr/bin/env bash

set -xeuo pipefail

# Enable the same compose repos that the centos-bootc base image uses
curl --retry 3 -Lo /etc/yum.repos.d/compose.repo https://gitlab.com/redhat/centos-stream/containers/bootc/-/raw/c10s/cs.repo
sed -r \
    -e 's@(baseos|appstream)@&-compose@' \
    -e 's@- (BaseOS|AppStream)@& - Compose@' \
    -e 's@/usr/share/distribution-gpg-keys/centos/RPM-GPG-KEY-CentOS-Official@/etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial-SHA256@' \
    -i /etc/yum.repos.d/compose.repo

# Remove subscription-manager, install EPEL and enable CRB
dnf -y remove subscription-manager
dnf config-manager --set-enabled crb
dnf -y install epel-release
#dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm

# Set global dnf options
dnf config-manager --save \
    --setopt=max_parallel_downloads=10

# FIXME: Workaround needed to remove intel microcode and nfs-utils..
mkdir -p /var/lib/rpm-state
touch /var/lib/rpm-state/microcode_ctl_un_{intel-ucode,ucode_caveats,file_list}
touch /var/lib/rpm-state/nfs-server.cleanup

# Remove unnecessary firmware and packages
dnf -y remove \
    adcli \
    atheros-firmware \
    brcmfmac-firmware \
    cirrus-audio-firmware \
    console-login-helper-messages \
    intel-audio-firmware \
    intel-gpu-firmware \
    insights-core \
    irqbalance \
    microcode_ctl \
    mt7xxx-firmware \
    nfs-utils \
    nvidia-gpu-firmware \
    nxpwireless-firmware \
    openssh-server \
    realtek-firmware \
    sos \
    sssd* \
    tiwilink-firmware \
    yggdrasil*

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
    usbutils

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
