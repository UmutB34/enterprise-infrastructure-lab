# Architecture

The lab is organized in layers. Each layer has one job, talks to its neighbours through a narrow interface, and can be replaced without rewriting the rest.

    Governance   decision register · approval gates · evidence rules
    Product      web product · deterministic analysis · multi-tenant data · billing provider layer
    Agents       coordinator · specialist agents · work queue · model gateway
    Knowledge    notes vault · hybrid search · canonical documents
    Quality      unit · integration · end-to-end · visual · accessibility · release gates
    Platform     hypervisor · containers · private access · backup · documentation sync

## Platform layer

| Component | Choice | Notes |
|---|---|---|
| Hypervisor | Proxmox VE | Containers for Linux services, virtual machines where a separate kernel is needed |
| Workloads | LXC containers, Ubuntu LTS | Separated by role so one workload does not share files or processes with another |
| Access | Private network, key-based administration | Administrative and automation keys are separate (see access-model.md) |
| Documentation | One writable source, read-only copies | See documentation-sync.md and ADR 0001 |
| Backup | Scheduled, off-host, restore-tested | See backup-recovery.md |

## Knowledge layer

A notes vault holds decisions, learnings and project context. Notes link to canonical documents instead of copying them. Search combines keyword ranking with meaning-based search, and every result points back to its source. No secrets enter the vault. See second-brain-knowledge-system.md.

## Agent layer

Work is routed by one coordinating role to specialist agents. A work queue controls how much runs in parallel. A model gateway sits between agents and language-model providers and handles authentication, per-consumer rate limits, fallback to a second provider, capacity limits per task type, a circuit breaker for failing providers, and an exception queue for work that needs a human. See agent-engine.md.

## Product layer

A web product for domain and e-mail security monitoring. Security findings and scores come from deterministic rules, not from a language model. Customer data is separated per tenant with row-level security, and the separation is checked with deliberate negative tests. Billing sits behind a provider-neutral layer so the payment provider can change without touching product code.

## Quality layer

Changes are checked at several levels before anyone calls them done. See quality-engineering.md.

## Governance layer

- Every open question has an age and a status in a decision register.
- Reports claim only what command output or a delivered artifact proves.
- Approvals for release, visual sign-off and outward actions can only be given by a human.
- Work runs in economy, normal or deep mode so cost and effort stay predictable.

## Design decisions

- **Containers before virtual machines** for Linux services: lower overhead, faster rebuilds.
- **One writable source of truth** for infrastructure documentation.
- **Deterministic where it matters.** Security checks and scoring are rules.
- **Narrow interfaces between layers**, so each can be tested and replaced on its own.

## Scaling path

The layers are designed to grow independently: a second hypervisor node for availability, replicated storage, network segmentation (see network-segmentation.md), and a larger agent queue with the same gateway rules.
