#!/usr/bin/env bash

set -xeuo pipefail

# Install only specific langpacks for needed languages/locales
dnf -y install glibc-langpack-{en,fi}

# Trimmed KDE installation
dnf -y install --setopt=install_weak_deps=False \
    alsa-ucm \
    alsa-utils \
    ark \
    bluedevil \
    breeze-gtk-gtk3 \
    colord-kde \
    dbus-daemon \
    default-fonts-core \
    dolphin \
    filelight \
    flatpak \
    flatpak-kcm \
    initscripts-rename-device \
    kate \
    kate-plugins \
    kcharselect \
    kcm-plasmalogin \
    kde-gtk-config \
    kde-partitionmanager \
    kde-settings-plasmalogin \
    kde-settings-pulseaudio \
    kdegraphics-thumbnailers \
    kdialog \
    kdnssd \
    kf6-baloo-file \
    kfind \
    kinfocenter \
    kio-admin \
    kjournald \
    konsole \
    kscreen \
    ksshaskpass \
    libappindicator-gtk3 \
    libstoragemgmt \
    libsysfs \
    mesa-vulkan-drivers \
    pam-kwallet \
    phonon-qt6-backend-vlc \
    pipewire \
    pipewire-alsa \
    pipewire-utils \
    plymouth-system-theme \
    plasma-desktop \
    plasma-discover \
    plasma-discover-flatpak \
    plasma-discover-notifier \
    plasma-disks \
    plasma-login-manager \
    plasma-milou \
    plasma-nm \
    plasma-pa \
    plasma-systemmonitor \
    prefixdevname \
    qt6-qtimageformats \
    samba-client \
    spectacle \
    upower \
    xfsdump \
    xsettingsd \
    zip

systemctl set-default graphical.target
