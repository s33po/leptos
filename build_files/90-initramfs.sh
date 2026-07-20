#!/usr/bin/env bash

set -xeuo pipefail

# Add plymouth and drm module
mkdir -p /etc/dracut.conf.d
echo 'add_dracutmodules+=" drm plymouth "' > /etc/dracut.conf.d/plymouth.conf

# Quiet boot
mkdir -p /usr/lib/bootc/kargs.d
cat > /usr/lib/bootc/kargs.d/plymouth.toml <<EOF
kargs = ["splash", "rhgb"]
EOF

# Generate initramfs
export DRACUT_NO_XATTR=1
kernel=$(rpm -q kernel | sort -V | tail -n1 | sed 's/^kernel-//')
/usr/bin/dracut --no-hostonly --kver "$kernel" --reproducible --zstd -v \
--add ostree -f "/lib/modules/$kernel/initramfs.img"
chmod 0600 /lib/modules/"$kernel"/initramfs.img
