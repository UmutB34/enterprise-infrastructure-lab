# Administrative access model

## Principles

1. **One key, one purpose.** Administrative access and automation access never share a key.
2. **Least privilege on the server side.** Automation keys are restricted on the server (forced command, no shell, read-only where possible), not only by convention on the client.
3. **Independent revocation.** Removing one line revokes one capability.
4. **A second way in.** Every critical system has an independent recovery path that does not depend on the first.
5. **Every change is reversible.** No access change is made without a backup and a test.

## Keys

| Key | Held by | Scope |
|---|---|---|
| Admin key | Admin workstation only | Interactive administration |
| Documentation pull key | Each container | Forced command: read-only fetch of one repository |
| Automation keys | One per workload | Only the commands that workload needs |

An example restriction is in examples/access/authorized_keys.example.

## Change procedure for access files

Access files are critical, so they are changed with discipline.

1. Confirm the second way in is available before editing.
2. Back up the file.
3. Make one change per command and verify with a fresh session before the next.
4. Transfer key material in binary-safe form, never through shell pipelines that can alter encoding or line endings.
5. Keep the existing session open until the new login is confirmed.

## Why this matters

Small, single-purpose, server-restricted keys limit the damage of any one leak, and a rehearsed change procedure keeps maintenance from becoming an outage. The same approach scales to production: separate roles, restricted automation, tested recovery.
