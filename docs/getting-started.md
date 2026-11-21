# Getting started: your first plugin

A plugin is a folder with a `shellcraft-plugin.toml` and the files it points to. This guide builds a
prompt segment that shows the current Kubernetes context, from nothing to installed.

You need shellcraft installed (`curl -fsSL https://raw.githubusercontent.com/cmdworks/shellcraft/main/install.sh | sh`).

## 1. Create it

```bash
shellcraft plugin new kube --kind segment
cd kube
```

This writes `shellcraft-plugin.toml` and `bin/segment`. The other kinds are `snippet`, `command`,
`hook` and `data`; see [plugin kinds](plugin-kinds.md).

## 2. Make it do something

`bin/segment` prints **one line**. An optional `[tone]` at the start picks a colour from the user's
theme (`git`, `version`, `tool`, `warn`, `dim`):

```sh
#!/bin/sh
ctx=$(kubectl config current-context 2>/dev/null) || exit 0   # print nothing when there is none
echo "[tool] k8s:$ctx"
```

Edit the manifest:

```toml
api = 1
name = "kube"
version = "0.1.0"
description = "Current Kubernetes context in the prompt"
license = "MIT"

[segment.main]
command = "bin/segment"
ttl_ms = 10000                        # how long the prompt reuses the output
when = { files = ["kustomization.yaml", "Chart.yaml"] }   # only in projects that have one of these

[permissions]
exec = ["kubectl"]
network = false
```

`when` keeps the prompt from running your script everywhere. The prompt never waits for a segment: it
shows the last cached line and refreshes in the background (2 second limit), so the first prompt in a
new directory shows nothing from your plugin.

## 3. Check it

```bash
shellcraft plugin check .
```

It validates the manifest, checks every referenced file exists and is executable, syntax-checks
snippets, and runs each segment once with its timing (anything over 50 ms is flagged).

## 4. Try it live

```bash
shellcraft plugin link .     # use it from this folder; edits to bin/segment apply at once
cd ~/some/project            # the segment shows after the first refresh
shellcraft remove kube       # removes the link, never your folder
```

After changing the manifest or a snippet, run `shellcraft apply`.

## 5. Install a copy, share it

```bash
shellcraft plugin add .                       # a pinned, hash-locked copy
shellcraft plugin add owner/repo@v0.1.0       # from GitHub once you pushed and tagged it
```

To get it into this repository (official) or the community list, see [publishing](publishing.md) and
[community plugins](community-plugins.md).

## Where to go next

- The complete manifest and what shellcraft guarantees: the
  [plugin API](https://github.com/cmdworks/shellcraft/blob/main/docs/plugin-api.md).
- Ideas and copyable examples: [plugin kinds](plugin-kinds.md), the official plugins in `plugins/`.
