# Writing a theme

A theme is a plugin with `kind = "theme"` and a `[theme.<name>]` table. It can change **colours**, and
the **shape of the prompt**. Users pick it with `shellcraft theme <name>`. Examples:
[`themes/colors`](../themes/colors) (colours only) and [`themes/passionp`](../themes/passionp)
(a full layout).

## Colours

```toml
[theme.mine]
dir = "38;5;110"       # SGR colour parameters: digits and ';' (34, 1;31, 38;5;110)
git = "35"
duration = "33"
ok = "32"
err = "31"
dim = "90"
version = "36"
tool = "94"
fzf = "--color=..."    # FZF_DEFAULT_OPTS value (optional)
bat = "Nord"           # BAT_THEME value (optional)
```

Anything left out keeps the default theme's value.

## Layout

Add `[theme.<name>.layout]` to decide what the prompt shows and where. Every field is optional; without
a layout table the theme keeps shellcraft's own prompt.

| Field | Meaning |
| :--- | :--- |
| `left` | parts of the prompt line, in order |
| `right` | parts at the right edge (zsh and fish); other shells ignore it |
| `dir_prefix` | text before the directory, for example an icon |
| `dir_lock` | text after the directory when it is not writable, painted in the `err` colour |
| `symbol_ok` | the prompt symbol after a successful command as pieces `"<sgr>:<text>"`, each in its own colour (`["1;31:❯", "1;33:❯", "1;32:❯"]`); empty: the configured symbol in the `ok` colour |
| `symbol_err` | the same after a failure; `{status}` is the exit status |
| `root_text`, `root_sgr` | the warning shown when the shell runs as root, and its colour (`41;37` is white on red) |
| `venv_prefix`, `aws_prefix` | text before the Python/conda/node environment name and the AWS profile |
| `duration_format` | how the last command's duration looks, `{d}` is the time (`"[{d}]"`) |
| `jobs_format` | how the background jobs look, `{n}` is the count |
| `min_duration_ms` | show the duration from this many milliseconds on; used while the user has not set `[prompt] min_duration_ms` (default 2000) |

Parts: `remote` (user@host over SSH), `root`, `venv` (virtualenv, conda, nvm), `aws` (`AWS_PROFILE`),
`dir`, `segments` (git, versions and other plugin segments), `duration`, `status` (`[N]` after a failure),
`jobs`, `symbol`. Left parts that have nothing to show are skipped and the rest are joined with a space;
right parts are joined without one. The duration appears when it is at least `[prompt] min_duration_ms`
(2000 by default; set it lower for a theme that shows milliseconds).

## Options for other plugins

`[theme.<name>.options.<plugin>]` sets defaults for that plugin's options while the theme is active; the
user's own `[plugin.<plugin>.options]` win. The git plugin understands:

| Option | Meaning |
| :--- | :--- |
| `prefix` | text before the branch (an icon) |
| `dirty` | text shown when the work tree has changes, in the `err` colour (default `*` in the warning colour) |
| `clean` | text shown when it has none, in the `ok` colour (default: nothing) |

Segment scripts of your own can use the tones `[ok]` and `[err]` to follow the theme.

## Fonts and icons

Icons are characters from a Nerd Font; write them as `\uXXXX` or `\UXXXXXXXX` escapes so the file stays
readable. Tell users which font they need in the description.

## Where the prompt comes from

A theme with a layout is drawn by `shellcraft prompt` in the background (zsh and fish show the previous
prompt of the same directory until the new one arrives; bash, nushell and PowerShell wait for it). The
default prompt is drawn inside the shell and is faster, so use a layout when you need the shape, not
only colours.
