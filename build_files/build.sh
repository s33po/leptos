#!/usr/bin/env bash
set -euo pipefail

BUILD_SCRIPTS_PATH="$(realpath "$(dirname "$0")")"

# List of build scripts to execute
SCRIPTS_TO_RUN=(
  "00-base.sh"
  "20-desktop.sh"
  "40-flatpak.sh"
  "50-conf.sh"
  "60-services.sh"
  "90-initramfs.sh"
)

# Loop over sorted scripts
for script in $(printf "%s\n" "${SCRIPTS_TO_RUN[@]}" | sort -V); do
  full_path="${BUILD_SCRIPTS_PATH}/${script}"
  base=$(basename "$full_path")
  printf "::group:: ===== ${base} =====\n"
  "$full_path"
  printf "::endgroup::\n"
done

# Cleanup
printf "::group:: ===== Image Cleanup =====\n"
"${BUILD_SCRIPTS_PATH}/cleanup.sh"
printf "::endgroup::\n"
