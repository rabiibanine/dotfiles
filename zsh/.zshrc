# ─────────────────────────────────────
# Starship prompt
# ─────────────────────────────────────
eval "$(starship init zsh)"
eval "$(mise activate zsh)"

# ─────────────────────────────────────
# Zsh Autosuggestions
# ─────────────────────────────────────
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ─────────────────────────────────────
# Zsh Syntax Highlighting
# IMPORTANT: keep this near the end
# ─────────────────────────────────────
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─────────────────────────────────────
# Zsh Exports
# ─────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────
# Database Management
# ─────────────────────────────────────

# `db` helper -- drives ~/projects/dotfiles/databases from anywhere.
# Every command it runs is printed first (lines starting with "+"), so you
# always see the exact docker/sql command behind each shortcut.
#
#   db up <postgres|oracle>     start an engine
#   db down <postgres|oracle>   stop it (data stays in its volume)
#   db status                   show database containers
#   db logs <postgres|oracle>   follow logs
#   db psql [dbname]            psql inside the postgres container
#   db sql [user]               SQLcl (`sql`) to Oracle FREEPDB1, prompts for password
#   db help                     this list, plus what each one expands to

# Print a command (shell-quoted) with a leading "+", then run it.
_db_run() {
  print -r -- "+ ${(j: :)${(@q-)@}}"
  "$@"
}

db() {
  local dir="$HOME/projects/dotfiles/databases"
  local action="${1:-help}" engine="${2:-}"
  local dc=(docker compose -f "$dir/compose.yaml")

  case "$action" in
    up|down|logs)
      case "$engine" in
        postgres|oracle) ;;
        *) echo "usage: db $action <postgres|oracle>"; return 1 ;;
      esac
      case "$action" in
        up)   _db_run "${dc[@]}" --profile "$engine" up -d ;;
        down) _db_run "${dc[@]}" --profile "$engine" down ;;
        logs) _db_run "${dc[@]}" --profile "$engine" logs -f "$engine" ;;
      esac
      ;;
    status|ps)
      _db_run "${dc[@]}" --profile postgres --profile oracle ps
      ;;
    psql)
      local dbargs=()
      [[ -n "$engine" ]] && dbargs=(-d "$engine")   # 2nd word = database name here
      _db_run "${dc[@]}" exec postgres psql -U "${POSTGRES_USER:-postgres}" "${dbargs[@]}"
      ;;
    sql)
      _db_run sql "${engine:-system}@//localhost:1521/FREEPDB1"
      ;;
    help|*)
      cat <<HELP
db up <postgres|oracle>    docker compose -f $dir/compose.yaml --profile <engine> up -d
db down <postgres|oracle>  docker compose -f $dir/compose.yaml --profile <engine> down
db status                  docker compose -f $dir/compose.yaml --profile postgres --profile oracle ps
db logs <postgres|oracle>  docker compose -f $dir/compose.yaml --profile <engine> logs -f <engine>
db psql [dbname]           docker compose -f $dir/compose.yaml exec postgres psql -U postgres [-d dbname]
db sql [user]              sql <user>@//localhost:1521/FREEPDB1   (user defaults to system)
HELP
      [[ "$action" == help ]] || return 1
      ;;
  esac
}
