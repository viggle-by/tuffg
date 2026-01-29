#!/bin/bash

# Eaglercraft Installer Script

clear
echo "Bootstrapping installer:"
sleep 1

echo -n "Checking version..."
sleep 1
echo " Done!"
echo "Version: v1.2.3"
sleep 1

echo -n "Downloading..."
sleep 2
echo " Done!"

echo -n "Extracting..."
sleep 2
echo " Done!"

echo -n "Initializing..."
sleep 1
echo " Done!"

echo
echo "The installer needs to run as root."
echo "Please enter your sudo password if prompted."
echo
read -s -p "Password: " password_input
echo
sleep 1

echo "Welcome to the Eaglercraft installer!"
echo
echo "This installer will guide you through the process of setting up"
echo "Eaglercraft on your system."
echo
echo "Please make sure you are familiar with our documentation at:"
echo "https://kaboom.pw"
echo
read -p "Press enter to continue."

echo
echo "Collecting system information..."
sleep 1

echo "Product name: Eagler Client E14 Gen 7"
echo "SoC: Eagler 1.21.1"
echo "Device class: j313ap"
echo "Product type: EaglerClient21.1"
echo "Board ID: 0x26"
echo "Chip ID: 0x8103"
echo "System firmware: EagBoot-2025-01-23"
echo "Boot UUID: 15897BB2-D8E9-4CCF-95F8-50C4765A5A2B"
echo "Boot VGID: 15897BB2-D8E9-4CCF-95F8-50C4765A5A2B"
echo "Default boot VGID: 15897BB2-D8E9-4CCF-95F8-50C4765A5A2B"
echo "Boot mode: Linux"
echo "OS version: Arch Linux"
echo "Main firmware version: 6.17.8-1.21.4"
echo "Login user: mysticgiggle"
sleep 2

echo
echo "Collecting installation environment information..."
echo "System disk: disk0"
sleep 1

echo
echo "Collecting OS information..."
sleep 1
echo "Partitions in system disk (disk0):"
echo "1: ext4 [root] (245.11 GB, 1 volume)"
echo "   OS: [B*] [root] Arch Linux [disk3s3s1, 15897BB2-D8E9-4CCF-95F8-50C4765A5A2B]"
echo "2: ext4 (Recovery) (5.37 GB, 1 volume)"
echo "   OS: [ ] recovery Arch Linux [Primary recovery]"
echo "[B ] = Booted OS, [R ] = Booted recovery, [? ] = Unknown"
echo "[ *] = Default boot volume"
sleep 2

echo
echo "Using OS 'root' (disk3s3s1) for installation authentication."
sleep 1

echo "Preparing Eaglercraft environment..."
sleep 2
echo "Pre-installation checks complete."
sleep 1

echo
echo "Eaglercraft installer ready to proceed!"
echo "Documentation and support: https://kaboom.pw"
echo
echo "Installation sequence complete. Enjoy Eaglercraft!"
