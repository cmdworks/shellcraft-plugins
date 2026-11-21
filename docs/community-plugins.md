# Community plugins

Plugins that live in other repositories can be listed here so that `shellcraft install <name>` finds
them. A listing is a pointer, not a copy: the code stays in the author's repository.

## How a listing works

`community/index.toml` has one entry per plugin, in the same format as the official index:

```toml
[[plugin]]
name = "todos"
version = "1.2.0"
description = "Count TODO comments in the prompt"
kind = "feature"
repo = "alice/shellcraft-todos"     # owner/repo or a git URL
rev = "v1.2.0"                      # a tag or commit, never a moving branch
hash = "3f1c...64 hex digits..."    # SHA-256 of the plugin files at that revision
```

Both `rev` and `hash` are required for a listing: they make the entry mean exactly the code that was
reviewed. If the author changes the code, the listing must change too, or shellcraft refuses the files.

Get the numbers by running `shellcraft registry publish` against a scratch registry and copying the
entry, or ask in the pull request.

## Getting listed

1. The plugin passes `shellcraft plugin check` and the [review checklist](review-checklist.md).
2. It has a README with what it does, how to remove it, and its license.
3. It is public, tagged, and the manifest tells the truth about permissions.
4. Open a pull request adding the entry. Reviewers read the code at that revision.

## Updating and removal

A new release is a new pull request (new `rev`, `version` and `hash`). Listings are removed when the
plugin is abandoned, becomes unsafe, or the author asks.

## Using a community plugin

```bash
shellcraft registry add cmdworks/shellcraft-plugins/community   # the community list as a registry
shellcraft install todos
```

Community plugins are labelled as such by the reviewers' description and are never embedded in the
shellcraft binary. Read the code before you install one: it runs as you.
