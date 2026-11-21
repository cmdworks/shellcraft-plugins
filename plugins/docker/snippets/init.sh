# --- docker compatibility (plugin: docker) ---
if ! command -v docker >/dev/null 2>&1 && command -v podman >/dev/null 2>&1; then alias docker=podman; fi
if command -v docker >/dev/null 2>&1 || command -v podman >/dev/null 2>&1; then
  alias d='docker'
  alias dc='docker compose'
  alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
  dsh() {
    local c; c=$(docker ps --format '{{.Names}}' | command shellcraft pick) || return
    docker exec -it "$c" sh -c 'command -v bash >/dev/null && exec bash || exec sh'
  }
  dlogs() {
    local c; c=$(docker ps -a --format '{{.Names}}' | command shellcraft pick) || return
    docker logs -f --tail 100 "$c"
  }
fi
