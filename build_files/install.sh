#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
PACKAGES_FILE="${SCRIPT_DIR}/packages.yml"

# Install EPEL and enable CRB
dnf -y install 'dnf-command(config-manager)' epel-release
dnf config-manager --set-enabled crb
dnf -y upgrade epel-release

dnf -y install yq

# Extract and install all packages from packages.yml in a single dnf call
if [[ ! -f "$PACKAGES_FILE" ]]; then
    printf 'Error: packages.yml not found at %s\n' "$PACKAGES_FILE" >&2
    exit 1
fi

mapfile -t packages < <(
    yq -r '
        if type == "!!seq" then
            .[]
        else
            error("expected a top-level YAML list")
        end
    ' "$PACKAGES_FILE"
)

if ((${#packages[@]} == 0)); then
    printf 'Error: no packages found in %s\n' "$PACKAGES_FILE" >&2
    exit 1
fi

dnf -y install --setopt=install_weak_deps=False "${packages[@]}"
