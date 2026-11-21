#!/usr/bin/env bash
# Regenerate the index entry of a plugin (version, description, kind, content hash):
#   scripts/publish.sh <name> [<name>...]     (no names: every plugin)
set -euo pipefail
cd "$(dirname "$0")/.."
command -v shellcraft >/dev/null || { echo "install shellcraft first" >&2; exit 1; }
names=("$@"); [ ${#names[@]} -gt 0 ] || { for d in plugins/*/; do names+=("$(basename "$d")"); done; }
for n in "${names[@]}"; do
  shellcraft registry publish . "./plugins/$n"
done
# older shellcraft versions record absolute folders; the index uses folders relative to this repository
# (current versions already do, this is then a no-op)
sed -i.bak -E "s#repo = \"[^\"]*/(plugins/[^\"/]+)\"#repo = \"\1\"#" index.toml && rm -f index.toml.bak
git diff --stat index.toml || true
