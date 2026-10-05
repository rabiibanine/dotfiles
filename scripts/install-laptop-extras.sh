#!/usr/bin/env bash
# Laptop-only extras — run after install-base.sh.
# Currently just keyd, for the laptop's broken keys. Add more sections here
# if the laptop ever needs something else the VM/other machines don't.
# Safe to re-run.
set -euo pipefail

DOTFILES="$HOME/projects/dotfiles"
if [ ! -d "$DOTFILES" ]; then
  echo "!! $DOTFILES not found — run install-base.sh first."
  exit 1
fi

# --- 1. keyd — remap the laptop's broken keys --------------------------------
# m/,/./ are physically broken; repurposed through a Left Alt layer rather
# than replacing keycaps. Left Alt is already keyd's predefined modifier
# layer (leftalt = layer(alt)), so anything NOT remapped in it — Alt+Tab
# included, which niri's config binds to Noctalia's window switcher — keeps
# passing the Alt modifier through untouched. No separate passthrough rule
# needed for that or any other Alt combo you add later.
#
# keyd's config lives under /etc, outside $HOME, so unlike the rest of the
# dotfiles this isn't a stow package — it's copied into place instead.
sudo pacman -S --needed --noconfirm keyd
sudo install -Dm600 "$DOTFILES/system/etc/keyd/default.conf" /etc/keyd/default.conf
sudo systemctl enable --now keyd
# Lets `keyd reload` / `keyd monitor` run without sudo.
sudo usermod -aG keyd "$USER"

echo "==> Laptop extras done. Reboot (needed for the keyd group membership"
echo "    to take effect) and test the broken-key remaps."
