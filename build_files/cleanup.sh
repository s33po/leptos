#!/usr/bin/env bash
set -euo pipefail
shopt -s nocaseglob nullglob

# Remove Fedora Plasma look-and-feel
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.{fedora,fedoralight,fedoradark}.desktop
rm -rf /usr/share/sddm/themes/01-breeze-fedora

# Remove Fedora wallpapers (nocaseglob matches F4*/f4* variants)
rm -rf /usr/share/wallpapers/Fedora
rm -rf /usr/share/wallpapers/f4*
rm -rf /usr/share/backgrounds/f4*

# Remove offline docs
rm -rf /usr/share/doc
