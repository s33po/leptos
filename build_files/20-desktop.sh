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
    kate \
    kate-plugins \
    kcharselect \
    kcm-plasmalogin \
    kde-gtk-config \
    kde-partitionmanager \
    kde-settings-plasmalogin \
    kdegraphics-thumbnailers \
    kdialog \
    kf6-baloo-file \
    kfind \
    kinfocenter \
    kio-admin \
    kjournald \
    konsole \
    kscreen \
    ksshaskpass \
    mesa-vulkan-drivers \
    pam-kwallet \
    pipewire \
    plymouth-system-theme \
    plasma-desktop \
    plasma-discover \
    plasma-discover-flatpak \
    plasma-disks \
    plasma-login-manager \
    plasma-milou \
    plasma-nm \
    plasma-pa \
    plasma-systemmonitor \
    qt6-qtimageformats \
    samba-client \
    spectacle \
    upower \
    xfsdump \
    zip

systemctl set-default graphical.target
