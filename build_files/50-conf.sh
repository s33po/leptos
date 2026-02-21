#!/usr/bin/env bash

set -xeuo pipefail

# Disable lastlog display
authselect enable-feature with-silent-lastlog

# Add user.just to image
install -Dm644 /ctx/build_files/user.just /usr/share/just/user.just

# Create global alias for user.just commands
echo "alias jmain='just --justfile /usr/share/just/user.just'" > /etc/profile.d/jmain.sh
chmod 644 /etc/profile.d/jmain.sh

# Use breezedark by default
sed -i 's|^LookAndFeelPackage=.*|LookAndFeelPackage=org.kde.breezedark.desktop|' \
  /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

sed -i 's|^ColorScheme=.*|ColorScheme=BreezeDark|' \
  /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals
