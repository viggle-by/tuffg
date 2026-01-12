#!/bin/bash
set -e

### PRE-CHECK ###
if [[ ! -d /sys/firmware/efi ]]; then
  echo "UEFI system required."
  exit 1
fi

timedatectl set-ntp true

### DISK SELECTION ###
echo "Available disks:"
lsblk -dpno NAME,SIZE | grep -E "sd|nvme|vd"

read -rp "Enter disk to install to (e.g. /dev/sda): " DISK
[[ ! -b "$DISK" ]] && echo "Invalid disk." && exit 1

echo "WARNING: This will ERASE $DISK"
read -rp "Type YES to continue: " CONFIRM
[[ "$CONFIRM" != "YES" ]] && exit 1

### SYSTEM INFO ###
read -rp "Hostname: " HOSTNAME
read -rp "Username: " USERNAME
read -rp "Timezone (e.g. America/New_York): " TIMEZONE
read -rp "Locale (e.g. en_US.UTF-8): " LOCALE

### PARTITIONING ###
sgdisk --zap-all "$DISK"
sgdisk -n 1:0:+1G -t 1:ef00 "$DISK"
sgdisk -n 2:0:0   -t 2:8300 "$DISK"

if [[ "$DISK" =~ nvme ]]; then
  EFI="${DISK}p1"
  ROOT="${DISK}p2"
else
  EFI="${DISK}1"
  ROOT="${DISK}2"
fi

mkfs.fat -F32 "$EFI"
mkfs.ext4 "$ROOT"

mount "$ROOT" /mnt
mkdir -p /mnt/boot
mount "$EFI" /mnt/boot

### PACKAGES ###
pacstrap /mnt \
  base base-devel linux linux-firmware \
  networkmanager sudo \
  pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
  refind efibootmgr \
  git nano firefox dolphin konsole \
  ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji \
  plasma-meta kde-applications xdg-desktop-portal-kde \
  cosmic cosmic-session \
  hyprland wayland xorg-xwayland \
  wl-clipboard grim slurp swaybg mako \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  polkit-kde-agent \
  kotlin

genfstab -U /mnt >> /mnt/etc/fstab

### CHROOT ###
arch-chroot /mnt /bin/bash <<EOF
set -e

### TIME / LOCALE ###
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
sed -i "s/#$LOCALE/$LOCALE/" /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

### HOST ###
echo "$HOSTNAME" > /etc/hostname
cat <<HOSTS > /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 $HOSTNAME.localdomain $HOSTNAME
HOSTS

### PASSWORDS ###
echo "Set ROOT password:"
passwd

useradd -m -G wheel -s /bin/bash $USERNAME
echo "Set password for $USERNAME:"
passwd $USERNAME

sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

### SERVICES ###
systemctl enable NetworkManager
systemctl enable sddm

### rEFInd ###
refind-install
sed -i 's/#scan_all_linux_kernels/scan_all_linux_kernels/' /boot/EFI/refind/refind.conf

PARTUUID=\$(blkid -s PARTUUID -o value $ROOT)

cat <<REFIND > /boot/EFI/refind/refind_linux.conf
"Arch Linux" "root=PARTUUID=\$PARTUUID rw quiet loglevel=3"
REFIND

### rEFInd Minecraft THEME ###
cd /root
git clone https://github.com/Minecraftian14/rEFInd-Minecraft.git
cd rEFInd-Minecraft
kotlin Build.kt build bakebg bakebg.osicons=2 bakebg.othericons=1

mkdir -p /boot/EFI/refind/themes
cp -r build/rEFInd-Minecraft /boot/EFI/refind/themes/minecraft
echo "include themes/minecraft/theme.conf" >> /boot/EFI/refind/refind.conf

### POLKIT AUTOSTART ###
mkdir -p /etc/xdg/autostart
cat <<POLKIT > /etc/xdg/autostart/polkit-kde-agent.desktop
[Desktop Entry]
Type=Application
Name=Polkit KDE Agent
Exec=/usr/lib/polkit-kde-authentication-agent-1
POLKIT

EOF

### FINISH ###
umount -R /mnt
echo "Installation complete. Reboot."
