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
    echo "Error: packages.yml not found at $PACKAGES_FILE" >&2
    exit 1
fi

echo "Installing packages from packages.yml..."
packages=$(grep -E '^\s+-\s+' "$PACKAGES_FILE" | sed 's/^\s*-\s*//;s/\s*$//' | tr '\n' ' ')

if [[ -z "$packages" ]]; then
    echo "Error: No packages found in packages.yml" >&2
    exit 1
fi

dnf -y install --setopt=install_weak_deps=False $packages
