#!/usr/bin/env bash
# Arch Linux base setup — niri + Noctalia (Catppuccin Mocha)
# Run after archinstall (Minimal profile) has already created your user
# and set the hostname. Safe to re-run — most steps are no-ops if already done.
set -euo pipefail

# --- 1. Detect VM vs laptop by hostname ---------------------------------
# You name VMs pizzahub-vm and the real machine pizzahub-laptop, so this
# is what gates the VMware-only packages/services/workarounds below.
HOST="$(hostname)"
case "$HOST" in
  pizzahub-vm)     IS_VM=true  ;;
  pizzahub-laptop) IS_VM=false ;;
  *)
    echo "Unrecognized hostname '$HOST' — expected pizzahub-vm or pizzahub-laptop."
    exit 1
    ;;
esac
echo "==> Host: $HOST (VM: $IS_VM)"

# --- 2. Update the system first ------------------------------------------
sudo pacman -Syu --noconfirm

# --- 3. Core packages — identical on VM and laptop ------------------------
# niri + noctalia: compositor + shell (bar/launcher/notifications/
#   wallpaper/lock all in one, replacing the earlier waybar/fuzzel/mako/
#   swaybg/hyprlock/swayidle set once Noctalia was adopted).
# xwayland-satellite: lets X11-only apps run under niri.
# xdg-desktop-portal-gnome/-gtk: screen sharing + file pickers — niri
#   specifically documents pairing with the GNOME portal.
# polkit: base mechanism for privilege prompts (Noctalia has its own
#   agent, toggled in Settings, so no separate *-polkit package needed).
# greetd: login manager; launches noctalia-greeter (installed below).
# kitty/zsh/+plugins/starship/stow: shell + terminal + dotfiles manager.
# fonts: JetBrains Mono Nerd Font for icons, Noto for script/emoji fallback
#   so nothing renders as empty boxes.
# git/curl/wget/unzip/lazygit/ripgrep/fd/fzf: general tooling + Neovim deps.
# neovim/base-devel: editor + what Mason/treesitter need to compile things
#   natively (base-devel's gcc is also the compiler clangd needs on the
#   PATH — clangd and clang-format themselves are installed through Mason
#   inside Neovim, not as system packages, so they stay pinned per-editor
#   instead of drifting with system updates; base-devel also covers
#   building noctalia-greeter below).
# mise/uv/opencode: language version management + AI coding agent.
PACKAGES=(
  niri noctalia xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk polkit
  greetd
  kitty zsh zsh-syntax-highlighting zsh-autosuggestions starship stow
  ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
  git curl wget unzip lazygit ripgrep fd fzf
  neovim base-devel mise uv opencode
)
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# --- 4. VM-only packages + services ---------------------------------------
# open-vm-tools/gtkmm3/libxtst: VMware guest integration (clipboard,
# drag-and-drop, resolution sync). None of this applies on real hardware.
if $IS_VM; then
  sudo pacman -S --needed --noconfirm open-vm-tools gtkmm3 libxtst
  sudo systemctl enable --now vmtoolsd vmware-vmblock-fuse
fi

# --- 5. Install yay (AUR helper) -------------------------------------------
# yay is itself AUR-only, so it needs the same raw git clone + makepkg
# bootstrap noctalia-greeter used before — but only once, for yay itself.
# The actual benefit isn't a "more reliable" build (same makepkg either
# way) — it's dependency resolution across AUR packages and being able to
# run `yay -Syu` to update official + AUR packages together going forward,
# since noctalia-greeter is unlikely to be the last AUR package you want.
if ! command -v yay &>/dev/null; then
  BUILD_DIR="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$BUILD_DIR"
  (cd "$BUILD_DIR" && makepkg -si --noconfirm)
  rm -rf "$BUILD_DIR"
fi

# --- 6. Install noctalia-greeter via yay ------------------------------------
yay -S --noconfirm --needed noctalia-greeter

# --- 7. greetd config ------------------------------------------------------
# On the VM specifically, noctalia-greeter's bundled compositor can't get
# a working GPU path and dies silently on boot — LIBGL_ALWAYS_SOFTWARE=1
# forces software rendering, scoped to just the greeter process (confirmed
# it does not carry over into the real niri session). Real hardware on the
# laptop doesn't need this, so it only applies when IS_VM is true.
GREETER_CMD="/usr/bin/noctalia-greeter-session"
if $IS_VM; then
  GREETER_CMD="env LIBGL_ALWAYS_SOFTWARE=1 $GREETER_CMD"
fi

sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "$GREETER_CMD"
user = "greeter"
EOF

sudo systemctl enable greetd

# --- 8. Login shell ---------------------------------------------------------
# archinstall doesn't set zsh as the login shell by default.
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  sudo chsh -s /usr/bin/zsh "$USER"
fi

# --- 9. Dotfiles -------------------------------------------------------------
# Everything below is symlinked from the repo via stow, so this script never
# needs editing when a config file's *contents* change — only if a whole
# new package directory gets added to the repo.
DOTFILES="$HOME/projects/dotfiles"
if [ ! -d "$DOTFILES" ]; then
  echo "!! $DOTFILES not found. Clone your dotfiles repo there first:"
  echo "     git clone <your-repo-url> $DOTFILES"
  echo "   then re-run this script."
  exit 1
fi

cd "$DOTFILES"
stow -t ~ zsh nvim kitty starship niri noctalia mise

# --- 10. mise-managed toolchains ----------------------------------------------
mise install

echo "==> Done."
echo "    Reboot, log in through the greeter, confirm niri + Noctalia look right."
echo "    Then: Settings -> Shell -> Security -> Noctalia Greeter -> Sync Now"
echo "    (pushes your real wallpaper/palette to the login screen — this is a"
echo "     GUI action and a polkit-gated one-time password prompt, can't be scripted)"
