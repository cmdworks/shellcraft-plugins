# Contributing

Thank you for helping. This repository holds the official shellcraft plugins, their documentation
and the list of community plugins. Changes to the shellcraft program itself go to
[cmdworks/shellcraft](https://github.com/cmdworks/shellcraft).

## Ways to contribute

- **Fix or improve an official plugin**: edit `plugins/<name>/`, bump its `version`, open a pull request.
- **Add an official plugin**: open an issue first describing what it does and why it should be official
  (small, broadly useful, no network or account needed). Then follow [Getting started](docs/getting-started.md).
- **List a community plugin**: add an entry to `community/index.toml`
  ([docs/community-plugins.md](docs/community-plugins.md)). The plugin stays in your repository.
- **Improve the docs**: always welcome, no issue needed.

## Set up

```bash
curl -fsSL https://raw.githubusercontent.com/cmdworks/shellcraft/main/install.sh | sh
git clone https://github.com/cmdworks/shellcraft-plugins && cd shellcraft-plugins
shellcraft plugin link plugins/docker      # try a plugin straight from its folder
scripts/check-all.sh                       # validate every plugin and the index (CI runs it too)
```

## Rules for a pull request

1. One plugin or one topic per pull request.
2. `scripts/check-all.sh` passes (manifest valid, files present, snippets parse, segments run, index hashes match).
3. Changed a plugin? Raise its `version` and regenerate the index with `scripts/publish.sh <name>`.
   The index is generated, so do not edit `index.toml` by hand.
4. The manifest tells the truth: `[permissions]` lists what the plugin runs, whether it uses the network
   and where it writes. Shellcraft does not enforce this, people read it.
5. No telemetry, no downloading and executing code at runtime, no reading files unrelated to the
   plugin's purpose. Prebuilt binaries need an `https` URL, a SHA-256 and a link to their source.
6. Keep it small and fast: a prompt segment must print in well under 50 ms (`shellcraft plugin check` reports it).
7. Work in every shell the manifest claims (`shells = [...]`, or none for all) or say which it supports.
8. Follow the [review checklist](docs/review-checklist.md); reviewers use the same list.

## Commit and review

Short imperative commit messages ("docker: show the compose file name"). Reviewers aim to answer
within a week. A plugin that needs a newer shellcraft says so in its description until the manifest
has a minimum-version field.

## Licensing of contributions

By contributing you agree that your contribution is licensed under the MIT license of this repository
(inbound = outbound). Do not copy code you do not have the right to relicense.

## Conduct

Be kind and specific. Disagree with the code, not the person. Harassment of any kind is not tolerated
and leads to removal from the project. Report problems to the maintainers (see SECURITY.md for contact).
