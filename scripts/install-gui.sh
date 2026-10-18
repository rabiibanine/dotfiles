#!/usr/bin/env bash
# Graphical layer -- niri + Noctalia (Catppuccin Mocha) + greetd login screen.
# Run AFTER install-base.sh, on machines with a real display (VM, laptop).
# Never on WSL.
# Follow with install-vm-extras.sh or install-laptop-extras.sh.
# Safe to re-run -- most steps are no-ops if already done.
set -euo pipefail

if grep -qi microsoft /proc/version 2>/dev/null; then
  echo "!! This is WSL -- it has no display server of its own. Nothing to do here."
  exit 1
fi

DOTFILES="$HOME/projects/dotfiles"
if [ ! -d "$DOTFILES" ] || ! command -v stow &>/dev/null; then
  echo "!! Run install-base.sh first (needs the dotfiles repo and stow)."
  exit 1
fi

# --- 1. Graphical packages -------------------------------------------------
# niri + noctalia: compositor + shell (bar/launcher/notifications/
#   wallpaper/lock all in one).
# xwayland-satellite: lets X11-only apps run under niri.
# xdg-desktop-portal-gnome/-gtk: screen sharing + file pickers -- niri
#   specifically documents pairing with the GNOME portal.
# polkit: base mechanism for privilege prompts (Noctalia has its own
#   agent, toggled in Settings, so no separate *-polkit package needed).
# greetd: login manager; launches noctalia-greeter (installed below).
# kitty: terminal.
# fonts: JetBrains Mono Nerd Font for icons, Noto for script/emoji fallback
#   so nothing renders as empty boxes.
# wl-clipboard: Wayland clipboard (Neovim, scripts).
GUI_PACKAGES=(
  niri noctalia xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk polkit
  greetd
  kitty
  ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
  wl-clipboard
)
sudo pacman -S --needed --noconfirm "${GUI_PACKAGES[@]}"

# --- 2. Install yay (AUR helper) ---------------------------------------------
# yay is itself AUR-only, so it needs a raw git clone + makepkg bootstrap --
# but only once, for yay itself. Everything after this uses yay instead.
if ! command -v yay &>/dev/null; then
  BUILD_DIR="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$BUILD_DIR"
  (cd "$BUILD_DIR" && makepkg -si --noconfirm)
  rm -rf "$BUILD_DIR"
fi

# --- 3. AUR packages -----------------------------------------------------------
yay -S --noconfirm --needed noctalia-greeter zen-browser-bin

# --- 4. greetd config ----------------------------------------------------------
# Plain command -- assumes real hardware, since that's the common case.
# install-vm-extras.sh overwrites this file afterward with the VM's
# software-rendering workaround when needed.
sudo tee /etc/greetd/config.toml > /dev/null <<TOML
[terminal]
vt = 1

[default_session]
command = "/usr/bin/noctalia-greeter-session"
user = "greeter"
TOML

sudo systemctl enable greetd

# --- 5. Graphical dotfiles ------------------------------------------------------
cd "$DOTFILES"
stow -t ~ kitty niri noctalia

echo "==> GUI setup done."
echo "    Now run the matching install-*-extras.sh (VM or laptop), then reboot."
