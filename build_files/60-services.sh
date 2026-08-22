#!/usr/bin/env bash

set -xeuo pipefail

# Enable services
systemctl enable bootc-fetch-apply-updates.timer
systemctl enable plasmalogin.service
systemctl enable podman.socket

# Disable services
systemctl disable rpm-ostree-countme.timer
