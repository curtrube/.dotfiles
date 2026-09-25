#!/usr/bin/bash
set -euo pipefail

echo "==> Installing base packages"

sudo pacman -Syu --needed --noconfirm \
    bolt
    linux-firmware
    upower
    power-profiles-daemon

    hyprland
    hypridle
    hyprlock
    hyprsunset
    hyprcursor
    hyprland-preview-share-picker
    uwsm

    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-user-dirs

    polkit
    hyprpolkitagent
    gnome-keyring
    libsecret

    qt5-wayland
    qt6-wayland

    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber
    pavucontrol

    networkmanager
    iwd
    impala
    inetutils

    bluez
    bluez-utils
    bluetui

    ttf-jetbrains-mono-nerd
    ttf-cascadia-code-nerd
    ttf-cascadia-mono-nerd
    ttf-nerd-fonts-symbols

    brightnessctl 
    playerctl 
    grim
    slurp
    satty

    waybar
    wofi
    libnotify
    mako
    swayosd
    swaybg

    wl-clipboard
    imv
    zathura
    zathura-pdf-poppler


# user tools
    git
    bash-completion
    kitty
    tmux
    starship
    tree-sitter-cli
    neovim
    jq
    gzip
    unzip
    stow
    btop
    github-cli
    mise
    tldr
    postgresql-libs

docker
docker-buildx
docker-compose

1password
1password-cli

firefox
obsidian
spotify-launcher


     gnome-keyring \
    waybar wofi nautilus dunst kitty neovim jq unzip \
    firefox


    stow hyprland waybar wofi swaync kitty zsh starship neovim yazi zathura jq tlp \
    networkmanager iwd pipewire pipewire-pulse pipewire-alsa wireplumber \
    bluez bluez-utils polkit hyprpolkitagent \
    xdg-desktop-portal xdg-desktop-portal-hyprland upower \
    linux-firmware "$UCODE" \
    ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-nerd-fonts-symbols \
    grim slurp wf-recorder hyprsunset brightnessctl playerctl wl-clipboard

echo "==> Enabling network manager"
sudo systemctl enable --now NetworkManager.service iwd.service bluetooth.service upower.service

# /etc/NetworkManager/NetworkManager.conf

[device]
wifi.backend=iwd


sudo systemctl enable --now bluetooth.service 
sudo systemctl enable --now upower.service
# sudo systemctl enable --now tlp.service
sudo systemctl enable --now bolt.service
