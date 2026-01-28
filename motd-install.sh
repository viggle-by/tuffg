#!/bin/bash

set -e

MOTD_SCRIPT="/etc/profile.d/motd.sh"

# Require root
if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo)."
  exit 1
fi

cat <<'EOF' > "$MOTD_SCRIPT"
#!/bin/bash

# Interactive shells only
[[ $- != *i* ]] && return

echo
echo "Welcome to Arch Linux!"
echo "   > X.Org - KDE Plasma 6.6 - systemd"
echo
EOF

chmod +x "$MOTD_SCRIPT"

echo "MOTD installed."
