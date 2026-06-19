#!/usr/bin/env bash

set -xeuo pipefail

# Install only specific langpacks for needed languages/locales
dnf -y install glibc-langpack-{en,fi}

# Trimmed KDE with core apps and some weaker dependencies
dnf -y install --setopt=install_weak_deps=False \
    ark \
    breeze-gtk-gtk3 \
    default-fonts-core \
    dolphin \
    filelight \
    flatpak \
    flatpak-kcm \
    kate \
    kate-plugins \
    kcm-plasmalogin \
    kde-gtk-config \
    kde-partitionmanager \
    kde-settings-plasmalogin \
    kdegraphics-thumbnailers \
    kf6-baloo-file \
    kio-admin \
    kjournald \
    konsole \
    kscreen \
    ksshaskpass \
    mesa-vulkan-drivers \
    pam-kwallet \
    pipewire \
    pipewire-alsa \
    plymouth-system-theme \
    plasma-desktop \
    plasma-discover \
    plasma-discover-flatpak \
    plasma-disks \
    plasma-login-manager \
    plasma-milou \
    plasma-nm \
    plasma-pa \
    qt6-qtimageformats \
    samba-client \
    spectacle \
    upower

systemctl set-default graphical.target
