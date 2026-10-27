# enterprise-infrastructure-lab

> Infrastructure patterns, quality gates and an AI-agent operating model for a small engineering lab, documented the way they would be run in production.

## What it does and what it makes easier

- Turns 'how should this be run?' into short, reviewable documents: principles, a reference design, and how to prove it works.
- Makes reviews, audits and hand-overs easier, because every topic states its decisions, trade-offs and checks in one place.
- Shows how the layers of a modern stack fit together: platform, knowledge, agents, products, quality and governance.

## Architecture at a glance

```mermaid
%%{init: {"theme":"base","flowchart":{"curve":"basis","nodeSpacing":30,"rankSpacing":30},"themeVariables":{"lineColor":"#5B7BA6","primaryColor":"#EEF3FA","primaryBorderColor":"#5B7BA6","primaryTextColor":"#1D3557"}}}%%
flowchart TB
  classDef gov  fill:#FFF4E0,stroke:#C98A1B,color:#5A3B00,stroke-width:1.5px
  classDef own  fill:#EAF0F8,stroke:#5B7BA6,color:#1D3557,stroke-width:1.5px
  classDef eng  fill:#E8F3EC,stroke:#3D8B5A,color:#17432A,stroke-width:1.5px
  classDef prod fill:#F1ECFA,stroke:#7A5BB0,color:#2E1D57,stroke-width:1.5px
  classDef qa   fill:#FBECEC,stroke:#B24A4A,color:#5C1E1E,stroke-width:1.5px
  classDef know fill:#E6F4F7,stroke:#2F8FA3,color:#0F3F4A,stroke-width:1.5px
  classDef plat fill:#EDEDED,stroke:#6B6B6B,color:#222222,stroke-width:1.5px

  GOV["<b>GOVERNANCE</b><br/>decision register with ages<br/>approval gates only a human passes<br/>evidence before claims"]
  OWN["<b>OWNER SURFACE</b><br/>one management screen<br/>progress · decisions waiting · alerts"]
  ENG["<b>WORK ENGINE</b><br/>coordinator and specialist roles<br/>work queue · engine chain"]
  PRD["<b>PRODUCTS</b><br/>security monitoring · automation workflows<br/>privacy-minimised measurement"]
  QA["<b>QUALITY</b><br/>unit · integration · negative · end-to-end<br/>visual · accessibility · human-signed release"]
  PLT["<b>PLATFORM</b><br/>hypervisor · containers · VMs · private access<br/>backup with restore test · documentation sync"]
  KNW["<b>KNOWLEDGE</b><br/>notes vault · hybrid search<br/>canonical documents"]

  GOV -.->|"constrains every layer"| OWN
  OWN --> ENG --> PRD --> QA --> PLT
  ENG <-->|"read and write"| KNW

  class GOV gov
  class OWN own
  class ENG eng
  class PRD prod
  class QA qa
  class PLT plat
  class KNW know
```

The layers, from governance down to the platform. Topology, data flows and the host are drawn in docs/topology.md.

## Documents

| Area | Document | Status |
|---|---|---|
| Whole stack, hardware to services | docs/end-to-end-architecture.md | in use |
| Topology diagrams and layers (host, containers, VMs, app and service layers) | docs/topology.md | in use |
| Layered architecture and decisions | docs/architecture.md | in use |
| Administrative access model | docs/access-model.md | in use |
| Documentation as code | docs/documentation-sync.md | in use |
| Network segmentation and firewalling | docs/network-segmentation.md | reference pattern |
| Backup and recovery | docs/backup-recovery.md | reference pattern |
| Quality engineering (QA, E2E, release gates) | docs/quality-engineering.md | in use |
| Runnable examples: restore test, docs sync, access, Ansible, Terraform | examples/ | restore test runs and is tested; others checked, see examples/README.md |
| Product measurement with privacy by design | docs/measurement-and-privacy.md | reference pattern; implemented and tested, production rollout pending |
| Agent engine design | docs/agent-engine.md | in use |
| Personal knowledge system | docs/second-brain-knowledge-system.md | in use |
| Architecture decision records | docs/adr/ | in use |

Status: 'in use' means practiced in the lab. 'Reference pattern' means a design written for production-style use; where code exists, the status line says how far it has been rolled out.

## Principles

1. One source of truth, linked rather than copied.
2. Deterministic where it matters; models where judgement helps.
3. Evidence before claims; humans for gates.
4. Least privilege for every key, account and agent.
5. Narrow interfaces between layers, so each can be replaced.

## How to read this repository

Start with the end-to-end architecture, then read the topic that matches your question. Each document is short on purpose and ends with how to check it works.

## Sanitization

All host names, addresses and identifiers are removed or replaced. Example addresses use the documentation ranges in RFC 5737 (192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24).

## License

MIT. See LICENSE.
