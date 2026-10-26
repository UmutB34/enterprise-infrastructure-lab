# ADR 0001: Single source of truth for infrastructure documentation

- **Status:** Accepted
- **Date:** 2026-09-11

## Context

Infrastructure documentation existed as independent copies in each workload. Keeping them aligned with each other and with the live system was a manual task.

## Decision

Keep one git repository as the only writable copy. Workloads receive read-only clones through a scheduled pull, authenticated with a dedicated key that is restricted on the server to read-only access for that repository.

## Consequences

- One history, one place to edit, one place to review.
- Workloads cannot modify documentation or reach other repositories.
- Documentation is only as current as the last edit, so live state is still verified before a status claim is trusted.
- Copies lag the source by the pull interval.

## Alternatives considered

- **Per-workload documentation.** Rejected: it needs manual alignment.
- **Push from the source to every workload.** Rejected: it gives the source write credentials into every workload.
