# Justfile for system maintenance and configuration

[private]
default:
    @just --justfile /usr/share/just/user.just --list

# Update (system and flatpaks)
[group('System')]
update:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Updating system..."
    sudo bootc update

    echo "Updating Flatpaks..."
    flatpak update -y

    echo "System updated!"

# Update distrobox containers
[group('System')]
update-dbox:
    #!/usr/bin/env bash
    set -euo pipefail

    containers=$(distrobox list --no-color | tail -n +2 | awk 'NF {print $3}')

    if [[ -z "$containers" ]]; then
        echo "Nothing to do"
    else
        echo "$containers" | while read -r container; do
            distrobox upgrade "$container"
        done
    fi

# Clean system
[group('System')]
clean-system:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Cleaning Flatpak..."
    flatpak uninstall --unused -y

    echo "Cleaning Podman..."
    podman system prune -f
    podman volume prune -f

    echo "Cleaning ostree..."
    sudo rpm-ostree cleanup -bm

    echo "Cleaning logs..."
    sudo journalctl --vacuum-time=7d

    echo "System cleaned!"

# Install default flatpaks
[group('Flatpak')]
install-flatpaks:
    #!/usr/bin/env bash
    set -euo pipefail

    # Ensure Flathub is available
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Install default flatpaks
    if [[ ! -f /etc/flatpak/defpaks.list ]]; then
        echo "Error: list not found at /etc/flatpak/defpaks.list"
        exit 1
    fi

    xargs -a /etc/flatpak/defpaks.list -r flatpak install -y --noninteractive flathub
    echo "Flatpak installation complete!"
