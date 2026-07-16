#!/usr/bin/env bash

set -xeuo pipefail

# Install extra packages
dnf -y install \
    bc \
    btop \
    fastfetch \
    fzf \
    gum \
    just \
    mtr \
    nvtop \
    steam-devices \
    time \
    goose \
    tree
