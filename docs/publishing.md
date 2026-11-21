# Publishing

## For a plugin in this repository (official)

1. Put the plugin in `plugins/<name>/` (a theme goes in `themes/<name>/`) and raise `version` in its manifest whenever the files change.
2. Regenerate its index entry (version, description, kind, content hash):

   ```bash
   scripts/publish.sh <name>
   ```

3. `scripts/check-all.sh` must pass, then open a pull request (see [CONTRIBUTING](../CONTRIBUTING.md)).

`index.toml` is generated. Each entry holds `name`, `version`, `description`, `kind`, `repo` (the folder
or repository), an optional `rev` and the SHA-256 of the plugin's files. Shellcraft refuses to install
files that do not match the hash.

## For a plugin in your own repository

Tag releases and tell people to install `owner/repo@v1.2.3`; or get it listed so
`shellcraft install <name>` finds it: [community plugins](community-plugins.md).

## Versions

Plugin versions are free-form but please use `MAJOR.MINOR.PATCH`. `plugin update` compares nothing
cleverly: it re-fetches and compares content hashes, then applies. Keep `api = 1` in the manifest; a
plugin written for a newer plugin API than the user's shellcraft supports is refused with a clear message.

## Signing the index (maintainers)

```bash
shellcraft registry keygen ./index.key            # once; keep the secret key offline
shellcraft registry sign . --key ./index.key      # writes index.toml.sig next to index.toml
```

Users who run `shellcraft registry trust <public key>` then ignore any copy of this registry whose
signature does not verify. Commit `index.toml.sig` with every index change; never commit the key.

## Releasing the repository

Tag the repository `vX.Y.Z` after the index is regenerated and signed. shellcraft releases vendor a
tagged copy of this repository so that `install` works offline.
