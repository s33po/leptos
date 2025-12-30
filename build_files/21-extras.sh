#!/usr/bin/env bash

set -xeuo pipefail

# Install extra packages
dnf -y install \
    bc \
    btop \
    fastfetch \
    fzf \
    just \
    mtr \
    nvtop \
    steam-devices \
    time \
    tree
