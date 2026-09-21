# ─────────────────────────────────────
# Starship prompt
# ─────────────────────────────────────
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"

# ─────────────────────────────────────
# Zsh Autosuggestions
# ─────────────────────────────────────
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ─────────────────────────────────────
# Zsh Syntax Highlighting
# IMPORTANT: keep this near the end
# ─────────────────────────────────────
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
