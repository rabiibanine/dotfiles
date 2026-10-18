#!/usr/bin/env bash
# Arch Linux base setup -- shell + dev tooling, NO graphical stack.
# The one required layer for every machine (WSL, VM, laptop).
# Run after archinstall (Minimal profile), or inside an Arch WSL distro.
#
# Then, depending on the machine:
#   WSL     -> nothing else (WSL has no display server of its own)
#   VM      -> install-gui.sh, then install-vm-extras.sh
#   laptop  -> install-gui.sh, then install-laptop-extras.sh
#
# Add a package here ONLY if every machine needs it. Graphical packages
# belong in install-gui.sh.
# Safe to re-run -- most steps are no-ops if already done.
set -euo pipefail

IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null; then
  IS_WSL=true
fi

# --- 1. Update the system first ------------------------------------------
sudo pacman -Syu --noconfirm

# --- 2. Core packages -------------------------------------------------------
# zsh/+plugins/starship/stow: shell + prompt + dotfiles manager.
# git/curl/wget/unzip/lazygit/ripgrep/fd/fzf: general tooling + Neovim deps.
# btop/fastfetch/less/tree-sitter-cli: system monitor, system info, pager,
#   treesitter parser builds.
# neovim/base-devel: editor + what Mason/treesitter need to compile things
#   natively (base-devel's gcc is also the compiler clangd needs on the
#   PATH -- clangd/clang-format themselves come from Mason, not a system
#   package; base-devel also covers building yay and noctalia-greeter in
#   install-gui.sh).
# mise/uv/opencode: language version management + AI coding agent.
PACKAGES=(
  zsh zsh-syntax-highlighting zsh-autosuggestions starship stow
  git curl wget unzip lazygit ripgrep fd fzf btop fastfetch less tree-sitter-cli
  neovim base-devel
  mise uv opencode
)
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# --- 3. Dotfiles must exist before stow/mise below -----------------------
DOTFILES="$HOME/projects/dotfiles"
DOTFILES_REPO="git@github.com:rabiibanine/dotfiles.git"
if [ ! -d "$DOTFILES" ]; then
  echo "==> $DOTFILES not found, cloning $DOTFILES_REPO ..."
  mkdir -p "$(dirname "$DOTFILES")"
  # accept-new: trusts github.com's host key on first connect instead of
  # stopping at an interactive prompt (still refuses a CHANGED key).
  if ! GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" \
       git clone "$DOTFILES_REPO" "$DOTFILES"; then
    echo "!! Clone failed. Over SSH this usually means this machine has no SSH key"
    echo "   registered with GitHub yet (or no network). Fix that, or clone it by hand:"
    echo "     git clone $DOTFILES_REPO $DOTFILES"
    echo "   then re-run this script."
    exit 1
  fi
fi

# --- 4. Login shell -----------------------------------------------------------
# archinstall / a fresh WSL distro doesn't set zsh as the login shell.
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  sudo chsh -s /usr/bin/zsh "$USER"
fi

# --- 5. Dotfiles ----------------------------------------------------------------
# Only the packages every machine wants. Graphical packages (kitty, niri,
# noctalia) are stowed by install-gui.sh. keyd's config is copied into place
# by install-laptop-extras.sh.
cd "$DOTFILES"
stow -t ~ zsh nvim starship mise uv

# --- 6. mise-managed toolchains --------------------------------------------------
mise install

# --- 7. WSL only: systemd check ---------------------------------------------------
# systemd user services need this. Not scriptable from inside the
# distro -- WSL only picks it up after a restart triggered from Windows.
if [ "$IS_WSL" = true ]; then
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
fi

echo "==> Base setup done."
if [ "$IS_WSL" = true ]; then
  echo "    WSL needs nothing else. Optional: install-docker.sh (containers/databases)."
else
  echo "    Next: install-gui.sh, then the matching install-*-extras.sh, then reboot."
  echo "    Optional anywhere: install-docker.sh (containers/databases)."
fi
