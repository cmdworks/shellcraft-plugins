#!/usr/bin/env bash
# Validate every plugin and the index: `shellcraft plugin check` on each plugin and on each template,
# and the content hash of each plugin against index.toml. Run it before opening a pull request.
set -euo pipefail
cd "$(dirname "$0")/.."
command -v shellcraft >/dev/null || { echo "install shellcraft first" >&2; exit 1; }
fail=0
for dir in plugins/*/ templates/*/; do
  [ -f "$dir/shellcraft-plugin.toml" ] || continue   # templates/github-actions is not a plugin
  if shellcraft plugin check "$dir" >/dev/null 2>&1; then echo "ok    $dir"; else echo "FAIL  $dir"; shellcraft plugin check "$dir" || true; fail=1; fi
done
# the index must describe the files as they are now: publishing into a copy must change nothing
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
cp index.toml "$tmp/index.toml"
for dir in plugins/*/; do
  name=$(basename "$dir")
  shellcraft registry publish "$tmp" "$dir" >/dev/null
done
if ! diff <(grep -E '^(name|version|hash) ' index.toml) <(grep -E '^(name|version|hash) ' "$tmp/index.toml") >/dev/null; then
  echo "FAIL  index.toml is out of date: run scripts/publish.sh <name>"; fail=1
else
  echo "ok    index.toml matches the plugin files"
fi
exit $fail
