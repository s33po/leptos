#!/usr/bin/env bash
set -euo pipefail

CONTEXT_PATH="$(realpath "$(dirname "$0")/..")"
BUILD_SCRIPTS_PATH="$(realpath "$(dirname "$0")")"

# Copy files from system_files if the directory exists
if [ -d "${CONTEXT_PATH}/system_files" ]; then
  printf "::group:: ===== Copying files =====\n"
  cp -avf "${CONTEXT_PATH}/system_files/." /
  printf "::endgroup::\n"
fi

# List of build scripts to execute
SCRIPTS_TO_RUN=(
  "00-base.sh"
  "20-desktop.sh"
  "21-extras.sh"
  "40-flatpak.sh"
  "50-conf.sh"
  "60-services.sh"
)

printf "::group:: ===== Executing build scripts =====\n"

# Loop over sorted scripts
for script in $(printf "%s\n" "${SCRIPTS_TO_RUN[@]}" | sort -V); do
  full_path="${BUILD_SCRIPTS_PATH}/${script}"
  base=$(basename "$full_path")
  printf "::group:: ===== ${base} =====\n"
  "$full_path"
  printf "::endgroup::\n"
done

printf "::endgroup::\n"

# Cleanup
printf "::group:: ===== Image Cleanup =====\n"
"${BUILD_SCRIPTS_PATH}/cleanup.sh"
printf "::endgroup::\n"
