#!/usr/bin/env bash

set -xeuo pipefail

# Add user.just to image
install -Dm644 /build_files/user.just /usr/share/just/user.just

# Create global alias for user.just commands
echo "alias jmain='just --justfile /usr/share/just/user.just'" > /etc/profile.d/jmain.sh
chmod 644 /etc/profile.d/jmain.sh
