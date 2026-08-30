#!/usr/bin/env bash

set -xeuo pipefail

# Install only specific langpacks for needed languages/locales
dnf -y install glibc-langpack-{en,fi}

# Trimmed KDE installation
dnf -y install --setopt=install_weak_deps=False \
    ark \
    breeze-gtk-gtk3 \
    default-fonts-core \
    dolphin \
    filelight \
    flatpak \
    flatpak-kcm \
    fuse \
    kate \
    kate-plugins \
    kcm-plasmalogin \
    kde-gtk-config \
    kde-partitionmanager \
    kde-settings-plasmalogin \
    kdegraphics-thumbnailers \
    kdialog \
    kf6-baloo-file \
    kfind \
    kio-admin \
    kjournald \
    konsole \
    kscreen \
    ksshaskpass \
    mesa-dri-drivers \
    mesa-vulkan-drivers \
    pam-kwallet \
    pipewire \
    plasma-desktop \
    plasma-discover \
    plasma-discover-flatpak \
    plasma-disks \
    plasma-login-manager \
    plasma-milou \
    plasma-nm \
    plasma-pa \
    plymouth \
    plymouth-system-theme \
    qt6-qtimageformats \
    samba-client \
    spectacle \
    tuned \
    tuned-ppd \
    upower

systemctl set-default graphical.target
