#!/usr/bin/env bash
# VM-only extras — run after install-base.sh, VMware VM only.
# Safe to re-run.
set -euo pipefail

# --- 1. VMware guest integration ---------------------------------------------
# open-vm-tools/gtkmm3/libxtst: clipboard, drag-and-drop, resolution sync
# with the VMware host.
sudo pacman -S --needed --noconfirm open-vm-tools gtkmm3 libxtst
sudo systemctl enable --now vmtoolsd vmware-vmblock-fuse

# --- 2. greetd GPU workaround ---------------------------------------------------
# noctalia-greeter's bundled compositor can't get a working GPU path inside
# this VM and dies silently on boot — LIBGL_ALWAYS_SOFTWARE=1 forces software
# rendering, scoped to just the greeter process (confirmed it does not carry
# over into the real niri session). Overwrites the plain command install-base.sh
# wrote, since greetd only has the one config file.
sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "env LIBGL_ALWAYS_SOFTWARE=1 /usr/bin/noctalia-greeter-session"
user = "greeter"
EOF

echo "==> VM extras done. Reboot, log in through the greeter, confirm niri +"
echo "    Noctalia look right."
echo "    Then: Settings -> Shell -> Security -> Noctalia Greeter -> Sync Now"
echo "    (pushes your real wallpaper/palette to the login screen — this is a"
echo "     GUI action and a polkit-gated one-time password prompt, can't be scripted)"
