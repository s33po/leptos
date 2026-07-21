#!/usr/bin/env bash

set -xeuo pipefail

# Enable services
systemctl enable bootc-fetch-apply-updates.timer
systemctl enable firewalld.service
systemctl enable plasmalogin.service
systemctl enable podman.socket
systemctl enable systemd-resolved.service
systemctl enable tuned.service

# Disable services
systemctl disable rpm-ostree-countme.timer
