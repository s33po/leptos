#!/usr/bin/env bash

set -xeuo pipefail

# Virtualization support
dnf -y install --setopt=install_weak_deps=False \
    libvirt-daemon \
    libvirt-client \
    libvirt-daemon-kvm \
    virt-install \
    virt-viewer

# GUI
dnf -y install virt-manager

systemctl enable libvirtd
