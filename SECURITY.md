# Security

## Reporting a problem

Please do not open a public issue for a vulnerability. Use GitHub's private vulnerability reporting
on this repository (Security tab, "Report a vulnerability"). You will get an answer within a week.

## What is in scope

- A plugin in `plugins/` doing something its manifest and description do not say (network access,
  writing outside its purpose, collecting data).
- A flaw in the index, its hashes or its signature that lets a changed plugin pass as the reviewed one.
- A listed community plugin that was changed after review without its pinned commit and hash changing.

## The trust model, plainly

Plugins run as your user. Shellcraft does not sandbox them. What protects you:

- **Review**: official plugins are reviewed before merge ([checklist](docs/review-checklist.md)).
- **Pinning**: the index records each plugin's content hash; shellcraft refuses files that do not match,
  and re-checks them on every `apply`.
- **Declared permissions**: shown before install; they are information, not enforcement.
- **Signing** (when enabled): the index is signed; shellcraft ignores a registry whose signature does
  not match a key you trust.

Read a plugin before installing it, especially a community one.
