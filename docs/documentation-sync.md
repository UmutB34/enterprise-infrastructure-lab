# Documentation as Code — One-way Distribution

## Problem

Each workload container originally kept its own copy of infrastructure documentation.
The copies drifted: one documented a service as "not installed" while it had been
running for most of a day.

## Pattern

```text
host: canonical git repo (only writable copy)
   │
   │  git pull over SSH, every 15 minutes
   │  key restricted to git-upload-pack for this one repo
   ▼
container clones (read-only by convention, overwritten on every pull)
```

- Edits happen **only** in the canonical repository; git history is the change log.
- Containers pull on a schedule; local edits in a clone are discarded by design.
- Each pull is logged locally for troubleshooting.
- Old per-container copies were marked stale with a notice rather than deleted.

## Why pull, not push

- The host does not need credentials into the containers.
- A compromised container can read the docs, but cannot write back or reach
  any other repository or a shell on the host.

## Example

[examples/docs-sync/](../examples/docs-sync/)
