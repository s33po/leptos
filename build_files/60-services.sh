#!/usr/bin/env bash

set -xeuo pipefail

# Enable services
systemctl enable bootc-fetch-apply-updates.timer
systemctl enable podman.socket
systemctl enable sddm.service
systemctl enable systemd-resolved.service
systemctl enable tuned

# Disable services
systemctl disable rpm-ostree-countme.timer
