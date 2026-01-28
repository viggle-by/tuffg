#!/bin/bash

set -e

PACMAN_CONF="/etc/pacman.conf"

# Require root
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script as root (use sudo)."
  exit 1
fi

# Add kde-unstable repo if missing
if ! grep -q "^\[kde-unstable\]" "$PACMAN_CONF"; then
  echo "Adding [kde-unstable] repo to pacman.conf..."
  cat <<EOF >> "$PACMAN_CONF"

[kde-unstable]
Include = /etc/pacman.d/mirrorlist
EOF
else
  echo "[kde-unstable] repo already present."
fi

# Sync repos
echo "Updating package databases..."
pacman -Sy

# Install KDE Plasma, KDE apps, and Xorg (X11 session)
echo "Installing KDE Plasma, applications, and Xorg..."
pacman -S --needed \
  plasma-meta \
  kde-applications-meta \
  plasma-workspace-x11 \
  xorg-server \
  xorg-apps \
  xorg-xinit

echo "Done!"
echo "You can now select 'Plasma (X11)' from your display manager."
