#!/usr/bin/env bash
set -xeuo pipefail

BUILD_SCRIPTS_PATH="$(realpath "$(dirname "$0")")"

# Install packages
printf "::group:: ===== Install Packages =====\n"
"${BUILD_SCRIPTS_PATH}/install.sh"
printf "::endgroup::\n"

# Apply configs
printf "::group:: ===== Apply Configs =====\n"
"${BUILD_SCRIPTS_PATH}/config.sh"
printf "::endgroup::\n"

# Generate initramfs
printf "::group:: ===== Generate Initramfs =====\n"
"${BUILD_SCRIPTS_PATH}/initramfs.sh"
printf "::endgroup::\n"

# Final cleanup
printf "::group:: ===== Image Cleanup =====\n"
"${BUILD_SCRIPTS_PATH}/cleanup.sh"
printf "::endgroup::\n"
