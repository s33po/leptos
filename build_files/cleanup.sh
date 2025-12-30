#!/usr/bin/env bash

set -xeuo pipefail

# Remove Fedora Plasma look-and-feel
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.{fedora,fedoralight,fedoradark}.desktop
rm -rf /usr/share/sddm/themes/01-breeze-fedora

# Remove Fedora wallpapers
rm -rf /usr/share/wallpapers/Fedora
rm -rf /usr/share/wallpapers/F4*
rm -rf /usr/share/backgrounds/f4*

# Remove offline docs
rm -rf /usr/share/doc

# Prune unnecessary locales
find /usr/share/locale/* -mindepth 0 -maxdepth 0 \
    ! -name "en" ! -name "en_US" ! -name "fi" ! -name "fi_FI" ! -name "locale.alias" \
    -exec rm -rf {} + > /dev/null 2>&1 || true

find /usr/share/qt6/translations/qtwebengine_locales/* -mindepth 0 -maxdepth 0 \
    ! -name "en-US.pak" ! -name "fi.pak" \
    -exec rm -rf {} + > /dev/null 2>&1 || true

# Final cleanup
dnf clean all
find /var -mindepth 1 -delete
find /boot -mindepth 1 -delete
find /tmp -mindepth 1 -delete
