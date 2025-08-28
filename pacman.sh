  GNU nano 8.6             setup/pacman.sh                       
#!/bin/bash

# Update the system first
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S --noconfirm \
  alsa-utils alsa-firmware \
  bind \
  bluez bluez-utils \
  brightnessctl \
  dosfstools \
  firefox \
  fuse \
  jq \
  neovim \
  pipewire pipewire-pulse pipewire-alsa wireplumber \
  playerctl libdbusmenu-glib \
  sway swaylock swayidle swaybg waybar foot \
  unzip wget \
  wofi \
  xorg-xwayland
