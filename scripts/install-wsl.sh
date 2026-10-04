#!/usr/bin/env bash
# Arch Linux (WSL) setup — dev tooling only, no compositor/display stack.
# Run inside an Arch WSL distro. Standalone — doesn't build on install-base.sh,
# since nothing graphical here overlaps with the VM/laptop setup.
# Safe to re-run — most steps are no-ops if already done.
set -euo pipefail

# --- 1. Update the system first ------------------------------------------
sudo pacman -Syu --noconfirm

# --- 2. Dev tooling packages ------------------------------------------------
# No niri/noctalia/greetd/portals/polkit/fonts/kitty — WSL has no display
# server of its own, so none of the graphical or login-screen stack applies.
# zsh/+plugins/starship/stow: shell + dotfiles manager.
# git/curl/wget/unzip/lazygit/ripgrep/fd/fzf: general tooling + Neovim deps.
# neovim/base-devel: editor + what Mason/treesitter need to compile natively
#   (clangd/clang-format still come from Mason, not a system package, same
#   reasoning as the graphical machines).
# mise/uv/opencode: language version management + AI coding agent.
PACKAGES=(
  zsh zsh-syntax-highlighting zsh-autosuggestions starship stow
  git curl wget unzip lazygit ripgrep fd fzf
  neovim base-devel
  mise uv opencode
)
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# --- 3. Login shell -----------------------------------------------------------
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  sudo chsh -s /usr/bin/zsh "$USER"
fi

# --- 4. Dotfiles ----------------------------------------------------------------
# Only what makes sense without a display server — no niri/noctalia/kitty
# packages here, so those dotfiles packages are intentionally left unstowed.
DOTFILES="$HOME/projects/dotfiles"
if [ ! -d "$DOTFILES" ]; then
  echo "!! $DOTFILES not found. Clone your dotfiles repo there first:"
  echo "     git clone <your-repo-url> $DOTFILES"
  echo "   then re-run this script."
  exit 1
fi

cd "$DOTFILES"
stow -t ~ zsh nvim starship mise uv

# --- 5. mise-managed toolchains ----------------------------------------------
mise install

# --- 6. systemd check ------------------------------------------------------------
# OmniRoute's systemd user service needs this. Not scriptable from inside the
# distro — WSL only picks it up after a restart triggered from Windows.
if [ -d /run/systemd/system ]; then
  echo "==> systemd already active in this WSL instance."
else
  echo "==> systemd is NOT active yet. One-time fix:"
  echo "      1. Add to /etc/wsl.conf:"
  echo "           [boot]"
  echo "           systemd=true"
  echo "      2. From PowerShell (not inside the distro): wsl --shutdown"
  echo "      3. Reopen the distro."
fi

echo "==> WSL setup done."
