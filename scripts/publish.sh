#!/usr/bin/env bash
# Regenerate the index entry of a plugin (version, description, kind, content hash):
#   scripts/publish.sh <name> [<name>...]     (no names: every plugin)
set -euo pipefail
cd "$(dirname "$0")/.."
command -v shellcraft >/dev/null || { echo "install shellcraft first" >&2; exit 1; }
# arguments are folders (plugins/docker, themes/passionp) or bare names of a folder in either
dirs=()
for n in "$@"; do
  for d in "$n" "plugins/$n" "themes/$n"; do [ -f "$d/shellcraft-plugin.toml" ] && { dirs+=("$d"); break; }; done
done
[ $# -gt 0 ] || dirs=(plugins/*/ themes/*/)
for d in "${dirs[@]}"; do
  shellcraft registry publish . "./${d%/}"
done
# older shellcraft versions record absolute folders; the index uses folders relative to this repository
# (current versions already do, this is then a no-op)
sed -i.bak -E "s#repo = \"[^\"]*/((plugins|themes)/[^\"/]+)\"#repo = \"\1\"#" index.toml && rm -f index.toml.bak
git diff --stat index.toml || true
