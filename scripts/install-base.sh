#!/usr/bin/env bash
# Arch Linux base setup — niri + Noctalia (Catppuccin Mocha)
# Common to every machine. Run after archinstall (Minimal profile).
# Follow with install-vm-extras.sh or install-laptop-extras.sh depending
# on the machine — or neither, on anything that needs no extras.
# Safe to re-run — most steps are no-ops if already done.
set -euo pipefail

# --- 1. Update the system first ------------------------------------------
sudo pacman -Syu --noconfirm

# --- 2. Core packages -------------------------------------------------------
# niri + noctalia: compositor + shell (bar/launcher/notifications/
#   wallpaper/lock all in one).
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
#   PATH — clangd/clang-format themselves come from Mason, not a system
#   package; base-devel also covers building yay and noctalia-greeter).
# mise/uv/opencode: language version management + AI coding agent.
PACKAGES=(
  niri noctalia xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk polkit
  greetd
  kitty zsh zsh-syntax-highlighting zsh-autosuggestions starship stow
  ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
  git curl wget unzip lazygit ripgrep fd fzf btop fastfetch
  neovim base-devel mise uv opencode
)
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# --- 3. Dotfiles must exist before stow/mise below -----------------------
DOTFILES="$HOME/projects/dotfiles"
if [ ! -d "$DOTFILES" ]; then
  echo "!! $DOTFILES not found. Clone your dotfiles repo there first:"
  echo "     git clone <your-repo-url> $DOTFILES"
  echo "   then re-run this script."
  exit 1
fi

# --- 4. Install yay (AUR helper) ---------------------------------------------
# yay is itself AUR-only, so it needs a raw git clone + makepkg bootstrap —
# but only once, for yay itself. Everything after this uses yay instead.
if ! command -v yay &>/dev/null; then
  BUILD_DIR="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$BUILD_DIR"
  (cd "$BUILD_DIR" && makepkg -si --noconfirm)
  rm -rf "$BUILD_DIR"
fi

# --- 5. Install noctalia-greeter and zen-browser via yay -------------------------------------
yay -S --noconfirm --needed noctalia-greeter zen-browser

# --- 6. greetd config ----------------------------------------------------------
# Plain command — assumes real hardware, since that's the common case.
# install-vm-extras.sh overwrites this file afterward with the VM's
# software-rendering workaround when needed.
sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "/usr/bin/noctalia-greeter-session"
user = "greeter"
EOF

sudo systemctl enable greetd

# --- 7. Login shell -----------------------------------------------------------
# archinstall doesn't set zsh as the login shell by default.
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  sudo chsh -s /usr/bin/zsh "$USER"
fi

# --- 8. Dotfiles ----------------------------------------------------------------
# Only the packages every machine wants. keyd's config exists in the repo
# too, but is only copied into place by install-laptop-extras.sh.
cd "$DOTFILES"
stow -t ~ zsh nvim kitty starship niri noctalia mise uv

# --- 9. mise-managed toolchains --------------------------------------------------
mise install

echo "==> Base setup done."
echo "    If this machine needs extras (VM guest tools, laptop keyd, etc.),"
echo "    run the matching install-*-extras.sh script now, then reboot."
