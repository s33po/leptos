#!/usr/bin/env bash

set -xeuo pipefail

# Add Flathub
mkdir -p /etc/flatpak/remotes.d
curl --retry 3 -o /etc/flatpak/remotes.d/flathub.flatpakrepo "https://dl.flathub.org/repo/flathub.flatpakrepo"

# Add default flatpaks to defpaks.list
tee /etc/flatpak/defpaks.list <<EOF
io.github.DenysMb.Kontainer
org.fooyin.fooyin
org.gtk.Gtk3theme.Breeze
org.kde.gwenview
org.kde.haruna
org.kde.kcalc
org.kde.krdc
org.kde.okular
org.libreoffice.LibreOffice
org.mozilla.firefox
EOF

# Add gaming flatpaks to gaming.list
tee /etc/flatpak/gaming.list <<EOF
com.valvesoftware.Steam
com.discordapp.Discord
EOF
