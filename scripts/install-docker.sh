#!/usr/bin/env bash
# Docker layer -- optional, run AFTER install-base.sh on any machine that
# should run containers (WSL, VM, laptop). Needed for the databases/ setup.
# Safe to re-run.
set -euo pipefail

# --- 0. WSL needs systemd for the docker service ---------------------------
if grep -qi microsoft /proc/version 2>/dev/null && [ ! -d /run/systemd/system ]; then
  echo "!! systemd is not active in this WSL instance, so the docker service"
  echo "   can't start. Run install-base.sh and follow its systemd instructions"
  echo "   (wsl.conf + wsl --shutdown from PowerShell), then re-run this script."
  exit 1
fi

# --- 1. Packages ------------------------------------------------------------
# docker: the engine + CLI. docker-compose: the `docker compose` plugin.
sudo pacman -S --needed --noconfirm docker docker-compose

# --- 2. Service -------------------------------------------------------------
sudo systemctl enable --now docker.service

# --- 3. Run docker without sudo ----------------------------------------------
# NOTE: membership in the docker group is effectively root access on this
# machine (a container can mount the host filesystem). Fine for a personal
# dev box; just know that's the trade-off.
if ! id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
  sudo usermod -aG docker "$USER"
  NEEDS_RELOGIN=true
else
  NEEDS_RELOGIN=false
fi

# --- 4. Smoke test (via sudo, since the group change isn't active yet) -------
sudo docker run --rm hello-world >/dev/null && echo "==> Docker engine works."

echo "==> Docker setup done."
if [ "$NEEDS_RELOGIN" = true ]; then
  echo "    You were just added to the docker group. It only applies to NEW sessions:"
  echo "      - WSL: run 'wsl --shutdown' from PowerShell, then reopen the distro"
  echo "      - VM/laptop: log out and back in"
  echo "      - or, for this shell only: newgrp docker"
fi
