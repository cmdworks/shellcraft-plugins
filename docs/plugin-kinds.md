# Plugin kinds

A plugin combines any of these parts; the `kind` field (`feature`, `segment`, `shell`, `theme`, `tool`,
`profile`) is a label for people and search. Starting skeletons are in [`templates/`](../templates)
(`shellcraft plugin new <name> --kind <kind>` creates them). Field details are in the
[plugin API](https://github.com/cmdworks/shellcraft/blob/main/docs/plugin-api.md).

## Prompt segment

One executable, one line of output. See [getting started](getting-started.md); a real one is
[`plugins/docker`](../plugins/docker/bin/segment).

```toml
[segment.main]
command = "bin/segment"
ttl_ms = 10000
when = { files = ["Dockerfile"] }
```

Place it with `[prompt] segments = ["kube"]` in the user's config (or leave it: installed plugins are
appended after the listed ones).

## Command

`shellcraft <name> ...` runs your program and exits with its status.

```toml
[command.todo]
run = "bin/todo"
about = "manage TODOs"
```

The name may not be a built-in command or another plugin's command; install refuses it.

## Hook

A program started in the background on an event, with the details in environment variables
(`SHELLCRAFT_EVENT`, `SHELLCRAFT_CWD`, `SHELLCRAFT_OLDPWD`, `SHELLCRAFT_EXIT`, `SHELLCRAFT_DURATION_MS`,
`SHELLCRAFT_COMMAND`). Events: `cd` and `post` (a command finished). Hooks cannot block the prompt; keep
them short because slow ones can pile up.

```toml
[hook.notify]
event = "post"
run = "bin/notify"
```

## Shell snippet and slots

Code that runs inside the user's shell at startup, per shell:

```toml
[snippets]
zsh = "snippets/init.zsh"
bash = "snippets/init.bash"
fish = "snippets/init.fish"
```

For finer control attach code before or after a named part of the init script (`shellcraft plugin slots zsh`
lists them):

```toml
[[slot]]
shell = "zsh"
name = "aliases"
file = "slots/pre-aliases.zsh"
position = "before"
```

Snippets run as the user, unsandboxed: keep them small and syntax-check with `plugin check`.
A real one: [`plugins/docker`](../plugins/docker/snippets).

## Data: aliases, abbreviations, environment

No code at all:

```toml
[aliases]
gs = "git status -sb"
[abbr]
gco = "git checkout"
[env]
EDITOR = "nvim"
```

The user's own entries win. A real one: [`plugins/git-aliases`](../plugins/git-aliases).

## Theme

```toml
kind = "theme"

[theme.nord]
dir = "38;5;110"        # SGR colour parameters: digits and ';'
git = "38;5;139"
ok = "38;5;108"
err = "38;5;167"
# also: duration, dim, version, tool, fzf, bat
```

Missing fields keep the default theme's. Users pick it with `shellcraft theme nord`. A real one:
[`plugins/themes`](../plugins/themes).

## Cheat sheet

```toml
[cheat.git]
file = "cheats/git.txt"
```

`shellcraft cheat git` prints the file. A real one: [`plugins/cheats`](../plugins/cheats).

## Prebuilt binary

For plugins written in Rust, Go or anything compiled: ship executables per platform instead of
building on the user's machine.

```toml
[[binary]]
name = "todo"                       # referenced as @todo
target = "aarch64-apple-darwin"
url = "https://github.com/you/todo/releases/download/v1.0.0/todo-aarch64-apple-darwin.tar.gz"
sha256 = "...64 hex digits..."
archive = "tar.gz"                  # or "raw"

[command.todo]
run = "@todo"                       # also valid in segment commands and hook runs
```

The URL must be `https`, the SHA-256 is checked on install and again on every `apply`.

## Profile (a bundle)

`kind = "profile"` and a `requires` list: installing it installs the others first. A real one:
[`plugins/base`](../plugins/base).

```toml
kind = "profile"
requires = ["git-aliases", "docker"]
```
