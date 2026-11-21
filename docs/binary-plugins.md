# Plugins with compiled code

shellcraft never builds code on a user's machine. A plugin that needs a compiled program ships it
prebuilt, per platform, built by **your** CI and published as release assets. The rules are in the
[distribution page](https://github.com/cmdworks/shellcraft/blob/main/docs/plugin-distribution.md); this is the how-to.

## 1. Write the plugin as usual

```toml
api = 1
name = "todo"
version = "1.0.0"
description = "Count TODO comments"
license = "MIT"

[command.todo]
run = "@todo"            # @name means: the [[binary]] called todo
about = "list TODOs"
```

`@name` works wherever a program path is allowed: segment `command`, hook `run`, command `run`.

## 2. Build and publish the artifacts

Copy [`templates/github-actions/plugin-release.yml`](../templates/github-actions/plugin-release.yml) to
`.github/workflows/release.yml` in your plugin repository and set `BIN`. Push a **build tag**:

```bash
git tag build-1.0.0 && git push --tags       # any tag starting with "v" triggers the template; adjust `on.push.tags` to taste
```

CI builds for `aarch64-apple-darwin`, `x86_64-apple-darwin`, `x86_64-unknown-linux-musl` and
`aarch64-unknown-linux-musl`, uploads `todo-<target>.tar.gz` and a checksum for each, and prints the
manifest blocks (also attached to the release as `binary-blocks.toml`).

## 3. Put the blocks in the manifest, then release

A tag is a snapshot, so the manifest has to list the artifacts *before* the tag users install. That is why
the flow has two tags: the build tag produces the files, the release tag contains the manifest that
points at them.

```toml
[[binary]]
name = "todo"
target = "aarch64-apple-darwin"
url = "https://github.com/you/todo/releases/download/build-1.0.0/todo-aarch64-apple-darwin.tar.gz"
sha256 = "…64 hex digits…"
archive = "tar.gz"
member = "todo"
# …one block per target…
```

Commit the manifest and tag it `v1.0.0`. Users install `you/todo@v1.0.0` (or just `you/todo`).

## 4. Check it

```bash
shellcraft plugin check .                 # validates the blocks and the manifest
shellcraft install you/todo@v1.0.0        # downloads your platform's build, checks the SHA-256
```

A user on a platform you did not build gets a clear refusal naming the platforms the plugin supports.
For development without releases, `SHELLCRAFT_DEV_ARTIFACTS=<folder>` makes a `url` that is a bare
file name or `file://` path read from that folder (with the same checksum check).

## What is not supported

Building on install, install scripts, downloading code at runtime, and plain `http://` URLs. Keep
plugins that are only shell scripts, data or snippets as plain git repositories: they need none of this.
