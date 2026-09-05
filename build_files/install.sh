#!/usr/bin/env bash

set -xeuo pipefail

SCRIPT_DIR="$(dirname "$0")"
PACKAGES_FILE="${SCRIPT_DIR}/packages.yml"

# Install EPEL and enable CRB
dnf -y install 'dnf-command(config-manager)' epel-release
dnf config-manager --set-enabled crb
dnf -y upgrade epel-release

# Extract and install all packages from packages.yml in a single dnf call
if [[ ! -f "$PACKAGES_FILE" ]]; then
    printf 'Error: packages.yml not found at %s\n' "$PACKAGES_FILE" >&2
    exit 1
fi

mapfile -t packages < <(
    awk '
        /^[[:space:]]*-[[:space:]]+/ {
            sub(/^[[:space:]]*-[[:space:]]+/, "")
            sub(/[[:space:]]+#.*$/, "")   # Remove optional inline comments
            sub(/[[:space:]]+$/, "")      # Remove trailing whitespace
            if ($0 != "") print
        }
    ' "$PACKAGES_FILE"
)

if ((${#packages[@]} == 0)); then
    printf 'Error: No packages found in %s\n' "$PACKAGES_FILE" >&2
    exit 1
fi

printf 'Installing packages from %s...\n' "$PACKAGES_FILE"

dnf -y \
    --setopt=install_weak_deps=False \
    install \
    "${packages[@]}"
